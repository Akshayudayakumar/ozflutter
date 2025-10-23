import 'package:get/get.dart';
import 'package:ozone_erp/database/tables/export_insert.dart';
import 'package:ozone_erp/models/sale_types.dart';
import 'package:ozone_erp/models/sales_body.dart';
import 'package:ozone_erp/models/voucher_body.dart';
import 'package:ozone_erp/services/voucher_services.dart';

import '../../../api/backend.dart';
import '../../../api/dio_config.dart';
import '../../../data/app_data.dart';
import '../../../models/device_details.dart' as dev;
import '../../../models/general_details.dart';
import '../../../services/sales_service.dart';
import '../../../services/sync_services.dart';
import '../../../utils/utils.dart';

part '../../../models/sync_types.dart';

class SyncController extends GetxController {
  Map<String, String> syncDate = AppData().getSyncDates();
  List<String> syncingKeys = [];
  Map<String, String> errorMap = {};

  Future<void> saveSync(String key) async {
    //TODO: Sync Functionality here -->
    syncingKeys.add(key);
    update();
    await execute(key);
    DateTime now = DateTime.now();
    AppData().storeSyncDates(key, now.toString());
    syncDate[key] = now.toString();
    syncingKeys.remove(key);
    update();
  }

  Future<void> execute(String key) async {
    switch (key) {
      case SyncTypes.sale:
        await saleSync();
        break;
      case SyncTypes.order:
        await orderSync();
        break;
      case SyncTypes.salesReturn:
        await salesReturnSync();
        break;
      case SyncTypes.details:
        await syncGeneralDetails();
        break;
      case SyncTypes.device:
        await syncDeviceDetails();
        break;
      case SyncTypes.voucher:
        await voucherSync();
        break;
      case SyncTypes.itemStock:
        await updateStock();
        break;
      default:
        await Future.delayed(const Duration(seconds: 2));
    }
  }

  Future<void> voucherSync() async {
    List<String> idsToSync =
        (await VoucherBodySync().getNotSyncedVoucherBodySync())
            .map((e) => e['id'].toString())
            .toList();
    List<VoucherBody> vouchers = [];
    for (var id in idsToSync) {
      final voucher = await InsertVouchers().getVoucher(id);
      vouchers.add(voucher);
    }
    for (var voucher in vouchers) {
      final result = await VoucherRepository().createPaymentVoucher(voucher);
      result.fold((data) async {
        await VoucherBodySync()
            .updateVoucherBodySync(id: voucher.vid ?? '', status: 1);
        errorMap[SyncTypes.voucher] = '';
      }, (error) {
        errorMap[SyncTypes.voucher] = error;
      });
    }
  }

  Future<void> saleSync() async {
    List<String> idsToSync = (await SalesBodySync().getNotSyncedSalesBodySync())
        .map((e) => e['id'].toString())
        .toList();
    List<SalesBody> sales = [];
    for (var id in idsToSync) {
      final sale = await InsertSalesBody().getSalesBodyById(id);
      if (sale != null) {
        sales.add(sale);
      }
    }
    sales = sales
        .where(
          (element) => element.type == SaleTypes.sales,
        )
        .toList();
    for (var sale in sales) {
      final result = await SalesRepository().createSales(sale);
      result.fold((data) async {
        await SalesBodySync().updateSalesBodySync(id: sale.id ?? '', status: 1);
        errorMap[SyncTypes.sale] = '';
      }, (error) {
        errorMap[SyncTypes.sale] = error;
      });
    }
  }

  Future<void> orderSync() async {
    List<String> idsToSync = (await SalesBodySync().getNotSyncedSalesBodySync())
        .map((e) => e['id'].toString())
        .toList();
    List<SalesBody> sales = [];
    for (var id in idsToSync) {
      final sale = await InsertSalesBody().getSalesBodyById(id);
      if (sale != null) {
        sales.add(sale);
      }
    }
    sales = sales
        .where(
          (element) => element.type == SaleTypes.salesOrder,
        )
        .toList();
    for (var sale in sales) {
      final result = await SalesRepository().createSales(sale);
      await result.fold((data) async {
        await SalesBodySync().updateSalesBodySync(id: sale.id ?? '', status: 1);
        errorMap[SyncTypes.order] = '';
      }, (error) {
        errorMap[SyncTypes.order] = error;
      });
    }
    DioResponse dioResponse =
        await SyncServices().fetchDeviceDetails(userId: AppData().getUserID());

    if (dioResponse.hasError) {
      errorMap[SyncTypes.order] =
          dioResponse.dioError.response?.data['message'] ??
              'Could not fetch assigned orders';
      return;
    }
    final deviceDetails =
        dev.DeviceDetails.fromJson(dioResponse.response!.data);
    var result = deviceDetails.result;
    if (result == null) {
      errorMap[SyncTypes.order] =
          deviceDetails.message ?? 'Could not fetch assigned orders';
      return;
    }
    await InsertSalesOrders().insertSalesOrderList(result.salesOrders ?? []);
  }

  Future<void> salesReturnSync() async {
    List<String> idsToSync = (await SalesBodySync().getNotSyncedSalesBodySync())
        .map((e) => e['id'].toString())
        .toList();
    List<SalesBody> sales = [];
    for (var id in idsToSync) {
      final sale = await InsertSalesBody().getSalesBodyById(id);
      if (sale != null) {
        sales.add(sale);
      }
    }
    sales = sales
        .where(
          (element) => element.type == SaleTypes.salesReturn,
        )
        .toList();
    for (var sale in sales) {
      final result = await SalesRepository().createSales(sale);
      result.fold((data) async {
        await SalesBodySync().updateSalesBodySync(id: sale.id ?? '', status: 1);
        errorMap[SyncTypes.salesReturn] = '';
      }, (error) {
        errorMap[SyncTypes.salesReturn] = error;
      });
    }
  }

  var generalDetails = GeneralDetails().obs;
  var generalDetailsResult = Result().obs;

  Future<void> syncDeviceDetails() async {
    DioResponse dioResponse =
        await SyncServices().fetchDeviceDetails(userId: AppData().getUserID());
    if (!dioResponse.hasError) {
      final deviceDetails =
          dev.DeviceDetails.fromJson(dioResponse.response!.data);
      var result = deviceDetails.result;
      if (result == null) {
        var message = deviceDetails.message;
        Utils().cancelToast();
        Utils().showToast(message.toString());
      } else {
        await insertDeviceDetails(result);
        AppData().storeCompanyLogo(
            '${BackEnd.baseUrl}uploads/company/${result.companySettings?[0].logo ?? ''}');
        AppData().storeTaxInclude(result.config?.isTaxincluded ?? false);
      }
    } else {
      Utils().cancelToast();
      Utils().showToast('Something went wrong');
    }
  }

  Future<void> insertDeviceDetails(dev.Result result) async {
    for (var setting in result.companySettings ?? <dev.CompanySettings>[]) {
      await InsertCompanySettings().insertCompanySettings(setting);
    }
    await InsertConfig().insertConfig(result.config!);
    for (var company in result.company ?? <dev.Company>[]) {
      await InsertCompany().insertCompany(company);
    }
    await InsertDevice().insertDevice(result.device!);
    for (var pointSetting in result.pointSettings ?? <dev.PointSettings>[]) {
      await InsertPointSettings().insertPointSettings(pointSetting);
    }
    for (var tax in result.tax ?? <dev.Tax>[]) {
      await InsertTax().insertTax(tax);
    }
    for (var unit in result.unit ?? <dev.Unit>[]) {
      await InsertUnit().insertUnit(unit);
    }
    for (var category in result.category ?? <dev.Category>[]) {
      await InsertCategory().insertCategory(category);
    }
    for (var area in result.area ?? <dev.Area>[]) {
      await InsertArea().insertArea(area);
    }
    for (var billNumber in result.billnumber ?? <dev.Billnumber>[]) {
      await InsertBillNumber().insertBillNumber(billNumber);
    }
    for (var accType in result.accType ?? <dev.AccType>[]) {
      await InsertAccType().insertAccType(accType);
    }
    for (var accSubType in result.accSubType ?? <dev.AccSubType>[]) {
      await InsertAccSubType().insertAccSubType(accSubType);
    }
    for (var accMain in result.accMain ?? <dev.AccMain>[]) {
      await InsertAccMain().insertAccMain(accMain);
    }
    for (var accLedgers in result.accLedgers ?? <dev.AccLedgers>[]) {
      await InsertAccLedgers().insertAccLedgers(accLedgers);
    }
    for (var order in result.salesOrders ?? <dev.SalesOrders>[]) {
      await InsertSalesOrders().insertSalesOrder(order);
    }
  }

  Future<void> syncGeneralDetails() async {
    DioResponse dioResponse = await SyncServices().fetchGeneralDetails();
    if (!dioResponse.hasError) {
      generalDetails.value =
          GeneralDetails.fromJson(dioResponse.response!.data);
      var result = generalDetails.value.result;
      if (result == null) {
        var message = generalDetails.value.message;
        Utils().cancelToast();
        Utils().showToast(message.toString());
      } else {
        generalDetailsResult.value = result;
        await insertGeneralDetails(result);
      }
    } else {
      Utils().cancelToast();
      Utils().showToast('Something went wrong');
    }
  }

  Future<void> insertGeneralDetails(Result result) async {
    await InsertCustomers().insertCustomersBatch(result.customers ?? []);
    for (var priceList in result.priceList ?? <PriceList>[]) {
      await InsertPriceList().insertPriceList(priceList);
    }
    for (var priceListDetail
        in result.priceListDetails ?? <PriceListDetails>[]) {
      await InsertPriceListDetails().insertPriceListDetails(priceListDetail);
    }
  }

  Future<void> updateStock() async {
    final result = await SyncRepository().fetchStock();
    await result.fold((data) async {
      for (var update in data) {
        await InsertItems().updateItemStock(
            id: update.itemId ?? '',
            quantity: update.stock?.split('.')[0] ?? '');
      }
    }, (error) {
      errorMap[SyncTypes.itemStock] = error;
    });
  }
}
