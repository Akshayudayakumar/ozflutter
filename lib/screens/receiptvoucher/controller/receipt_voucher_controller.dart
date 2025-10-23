import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/models/device_details.dart';
import 'package:ozone_erp/models/general_details.dart';
import 'package:ozone_erp/models/state_model.dart';
import 'package:ozone_erp/services/location_services.dart';
import '../../../data/app_data.dart';
import '../../../database/tables/export_insert.dart';
import '../../../models/voucher_body.dart';
import '../../../routes/routes_class.dart';
import '../../../services/voucher_services.dart';

class ReceiptVoucherController extends GetxController {
  String previousRoute = Get.previousRoute;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  RxList<Customers> customers = <Customers>[].obs;
  Rx<Customers> selectedCustomer = Customers().obs;
  Rx<Billnumber> billNumber = Billnumber().obs;
  bool hasPreviousPage = Get.arguments != null;
  Rx<StateModel> state = StateModel.success.obs;
  RxString errorMessage = ''.obs;
  TextEditingController dateController = TextEditingController(
      text:
          '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}');
  TextEditingController fromAccount = TextEditingController();
  TextEditingController narration = TextEditingController();
  TextEditingController amount = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> getCustomers() async {
    customers.value = await InsertCustomers().getCustomers();
    billNumber.value = await InsertBillNumber()
        .getBillNumberByType(BillNumberTypes.quickReceipt);
  }

  Future<void> updateDate() async {
    final date = await showDatePicker(
        context: Get.context!,
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),
        initialDate: DateTime.now());
    if (date != null) {
      selectedDate.value = date;
      dateController.text = '${date.day}-${date.month}-${date.year}';
    }
  }

  @override
  void onInit() {
    getCustomers();
    super.onInit();
  }

  Future<void> save() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    state(StateModel.loading);
    final positionResult = await LocationRepository().getLocation();
    String invoiceNumber =
        '${billNumber.value.preffix ?? ''}${billNumber.value.seperator ?? ''}${billNumber.value.startnumber ?? ''}${billNumber.value.seperator ?? ''}${billNumber.value.suffix ?? ''}'
            .trim();
    String latitude = '';
    String longitude = '';
    await positionResult.fold((data) {
      latitude = data.latitude.toString();
      longitude = data.longitude.toString();
    }, (error) {});
    VoucherBody body = VoucherBody(
      aeging: [],
      amount: amount.text.trim(),
      billType: billNumber.value.id,
      createdBy: AppData().getUserID(),
      date: dateController.text.trim(),
      latitude: latitude,
      longitude: longitude,
      narration: narration.text.trim(),
      toid: selectedCustomer.value.id,
      type: 'Receipt',
      vid: invoiceNumber,
      voucherId: '0',
      loginUserId: AppData().getUserID(),
    );

    await InsertVouchers().insertVouchers(body);
    await InsertBillNumber().updateBillNumber(billNumber.value.copyWith(
        startnumber: (double.parse(billNumber.value.startnumber ?? '0') + 1)
            .round()
            .toString()));
    await VoucherBodySync().insertVoucherBodySync(id: invoiceNumber, status: 0);

    if (AppData().getSettings().syncOnSave ?? false) {
      final result = await VoucherRepository().createPaymentVoucher(body);
      result.fold((data) async {
        state(StateModel.success);
        await VoucherBodySync()
            .updateVoucherBodySync(id: invoiceNumber, status: 1);
        Get.offNamed(RoutesName.vouchers);
      }, (error) {
        state(StateModel.error);
        errorMessage(error);
      });
    } else {
      state(StateModel.success);
      Get.offNamed(RoutesName.vouchers);
    }
  }
}
