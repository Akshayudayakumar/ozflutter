import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/models/device_details.dart';
import 'package:ozone_erp/models/general_details.dart';
import 'package:ozone_erp/models/state_model.dart';
import 'package:ozone_erp/services/customer_services.dart';
import '../../../../api/api.dart';
import '../../../../database/tables/export_insert.dart';
import '../../../../routes/routes_class.dart';
import '../../../../services/location_services.dart';
import '../../../../services/sync_services.dart';
import '../../../../utils/utils.dart';

class CustomerTypes {
  final String id;
  final String name;

  CustomerTypes({required this.id, required this.name});
}
class CustomerRates {
  final String id;
  final String value;
  CustomerRates({required this.id, required this.value});
}
class AddCustomerController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController gstController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  Rx<StateModel> state = StateModel.loading.obs;
  Rx<StateModel> submitState = StateModel.success.obs;
  RxString errorMessage = ''.obs;
  RxString area = '0'.obs;
  RxString priceList = '0'.obs;
  RxString type = 'cus'.obs;
  RxList<Area> areas = <Area>[].obs;
  RxList<PriceList> priceLists = <PriceList>[].obs;
  RxList<CustomerRate> customerRate = <CustomerRate>[].obs;
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  RxBool isLocationLoading = false.obs;


  List<CustomerTypes> customerTypes = [
    CustomerTypes(id: 'cus', name: 'Customer'),
    CustomerTypes(id: 's' , name: 'Supplier'),
  ];

  List<CustomerRates> customerRates = [
    CustomerRates(id: 'srate', value: 'Srate'),
    CustomerRates(id: 'MRP', value:'MPR'),
    CustomerRates(id: 'wh_rate', value:'Wholesale Rate'),
    CustomerRates(id: 'special_rate', value:'Special Rate'),
    CustomerRates(id: 'last_srate', value:'Last Sales Rate')
  ];

  final formKey = GlobalKey<FormState>();

  @override
  void onClose() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    gstController.dispose();
    remarksController.dispose();
    super.onClose();
  }

  Future<void> getAreas() async {
    state.value = StateModel.loading;
    areas.value = await InsertArea().getArea();
    await getPriceList();
  }

  Future<void> getPriceList() async {
    priceLists.value = await InsertPriceList().getPriceList();
    state.value = StateModel.success;
  }

  Future<void> getLocation() async {
    isLocationLoading.value = true;
    final position = await LocationServices().getCurrentPosition();
    latitude.value = position.latitude;
    longitude.value = position.longitude;
    isLocationLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    getAreas();
    getLocation();
  }

  void selectArea(String area) {
    this.area.value = area;
  }

  void selectCustomerType(String cusType) {
    type.value = cusType;
  }

  void selectPriceList(String priceList) {
    this.priceList.value = priceList;
  }

  /// This method is called when the user tries to add a new customer.
  addCustomer() async {
    Utils.unfocus();
    Utils.hideKeyboard();
    if (formKey.currentState!.validate()) {
      submitState(StateModel.loading);
      formKey.currentState?.save();
      await LocationRepository().getLocation();

      final result = await CustomerRepository().addCustomer(
          name: nameController.text.trim(),
          phone: phoneController.text.trim(),
          address: addressController.text.trim(),
          gstNo: gstController.text.trim(),
          area: area.value,
          priceList: priceList.value,
          type: type.value,
          latitude: latitude.value,
          longitude: longitude.value,
          customerRate: customerRates
              .firstWhere((element) => element.id == type.value,
              orElse: () => CustomerRates(id: '0', value: '0'))
              .value,
          remarks: remarksController.text.trim()
      );
      await result.fold((error) {
        submitState(StateModel.error);
        errorMessage('Something went wrong, Please try again');
      },(data) async{
        await getCustomerDetails();
        print('Customer Added Successfully $data');
        Get.offAllNamed(RoutesName.newOrder,arguments:data);
        submitState(StateModel.success);
      }
        // Get.back(
        //     result: Customers(
        //         name: nameController.text.trim(),
        //         phone: phoneController.text.trim(),
        //         addressLine1: addressController.text.trim(),
        //         gst: gstController.text.trim(),
        //         area: area.value,
        //         priceList: priceList.value,
        //         type: type.value,
        //     latitude: latitude.value.toString(),
        //       longitude: longitude.value.toString(),
        //     ));
      );
    }
  }

  /// Fetches the latest general details (including customers) from the server
  /// and updates the local database.
  Future<void> getCustomerDetails() async {
    DioResponse dioResponse = await SyncServices().fetchGeneralDetails();
    if (dioResponse.hasError) {
      Utils().showToast('Something went wrong');
      return;
    }
    final generalDetails = GeneralDetails.fromJson(dioResponse.response!.data);
    if (generalDetails.result == null) {
      Utils().showToast(generalDetails.message.toString());
      return;
    }
    await InsertCustomers()
        .insertCustomersBatch(generalDetails.result?.customers ?? []);
  }
}
