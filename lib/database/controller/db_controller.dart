import 'package:get/get.dart';
import 'package:ozone_erp/screens/newsale/controller/new_sale_controller.dart';
import 'package:ozone_erp/screens/stockTransfer/controller/stock_transfer_controller.dart';

import '../../api/backend.dart';
import '../../api/dio_config.dart';
import '../../data/app_data.dart';
import '../../models/device_details.dart';
import '../../models/general_details.dart' as general_details;
import '../../routes/routes_class.dart';
import '../../services/sync_services.dart';
import '../../utils/utils.dart';
import '../tables/export_insert.dart';

class DBController extends GetxController {
  var deviceDetails = DeviceDetails().obs;
  var details = Result().obs;
  RxBool syncing = false.obs;

  var generalDetails = general_details.GeneralDetails().obs;
  var generalDetailsResult = general_details.Result().obs;

  @override
  onInit() {
    super.onInit();
    syncDeviceDetails();
  }

  Future<void> updateStock() async {
    final result = await SyncRepository().fetchStock();
    await result.fold((data) async {
      for (var update in data) {
        await InsertItems().updateItemStock(
            id: update.itemId ?? '',
            quantity: update.stock?.split('.')[0] ?? '');
      }
    }, (error) {});
  }

  Future<void> syncDeviceDetails() async {
    syncing.value = true;
    DioResponse dioResponse =
        await SyncServices().fetchDeviceDetails(userId: AppData().getUserID());
    if (!dioResponse.hasError) {
      deviceDetails.value = DeviceDetails.fromJson(dioResponse.response!.data);
      var result = deviceDetails.value.result;
      if (result == null) {
        var message = deviceDetails.value.message;
        syncing.value = false;
        Utils().cancelToast();
        Utils().showToast(message.toString());
      } else {
        details.value = result;
        await insertDeviceDetails(result);
        await syncGeneralDetails();
        await InsertUserModel().insertUserModel(AppData().getUser());
        await updateStock();
        AppData().storeCompanyLogo(
            '${BackEnd.baseUrl}uploads/company/${result.companySettings?[0].logo ?? ''}');
        AppData().storeTaxInclude(result.config?.isTaxincluded ?? false);
        Get.put<StockTransferController>(StockTransferController());
        Get.put<NewSaleController>(NewSaleController());
        Get.offNamedUntil(RoutesName.dashboard, (route) => false);
        syncing.value = false;
      }
    } else {
      Utils().cancelToast();
      syncing.value = false;
      Utils().showToast('Something went wrong');
    }
  }

  Future<void> syncGeneralDetails() async {
    syncing.value = true;
    DioResponse dioResponse = await SyncServices().fetchGeneralDetails();
    if (!dioResponse.hasError) {
      generalDetails.value =
          general_details.GeneralDetails.fromJson(dioResponse.response!.data);
      var result = generalDetails.value.result;
      if (result == null) {
        var message = generalDetails.value.message;
        syncing.value = false;
        Utils().cancelToast();
        Utils().showToast(message.toString());
      } else {
        generalDetailsResult.value = result;
        await insertGeneralDetails(result);
        syncing.value = false;
      }
    } else {
      Utils().cancelToast();
      syncing.value = false;
      Utils().showToast('Something went wrong');
    }
  }

  Future<void> insertGeneralDetails(general_details.Result result) async {
    for (var item in result.items ?? <general_details.Items>[]) {
      await InsertItems().insertItems(item);
    }
    await InsertCustomers().insertCustomersBatch(result.customers ?? []);
    for (var priceList in result.priceList ?? <general_details.PriceList>[]) {
      await InsertPriceList().insertPriceList(priceList);
    }
    for (var priceListDetail
        in result.priceListDetails ?? <general_details.PriceListDetails>[]) {
      await InsertPriceListDetails().insertPriceListDetails(priceListDetail);
    }
  }

  Future<void> insertDeviceDetails(Result result) async {
    for (var setting in result.companySettings ?? <CompanySettings>[]) {
      await InsertCompanySettings().insertCompanySettings(setting);
    }
    await InsertConfig().insertConfig(result.config!);
    for (var company in result.company ?? <Company>[]) {
      await InsertCompany().insertCompany(company);
    }
    await InsertDevice().insertDevice(result.device!);
    for (var pointSetting in result.pointSettings ?? <PointSettings>[]) {
      await InsertPointSettings().insertPointSettings(pointSetting);
    }
    for (var tax in result.tax ?? <Tax>[]) {
      await InsertTax().insertTax(tax);
    }
    for (var unit in result.unit ?? <Unit>[]) {
      await InsertUnit().insertUnit(unit);
    }
    for (var category in result.category ?? <Category>[]) {
      await InsertCategory().insertCategory(category);
    }
    for (var area in result.area ?? <Area>[]) {
      await InsertArea().insertArea(area);
    }
    for (var billNumber in result.billnumber ?? <Billnumber>[]) {
      await InsertBillNumber().insertBillNumber(billNumber);
    }
    for (var accType in result.accType ?? <AccType>[]) {
      await InsertAccType().insertAccType(accType);
    }
    for (var accSubType in result.accSubType ?? <AccSubType>[]) {
      await InsertAccSubType().insertAccSubType(accSubType);
    }
    for (var accMain in result.accMain ?? <AccMain>[]) {
      await InsertAccMain().insertAccMain(accMain);
    }
    for (var accLedgers in result.accLedgers ?? <AccLedgers>[]) {
      await InsertAccLedgers().insertAccLedgers(accLedgers);
    }
    for (var order in result.salesOrders ?? <SalesOrders>[]) {
      await InsertSalesOrders().insertSalesOrder(order);
    }
  }
}
