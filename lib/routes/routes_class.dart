import 'package:get/get.dart';
import 'package:ozone_erp/screens/dashboard/binding/dashboard_binding.dart';
import 'package:ozone_erp/screens/dashboard/screens/dashboard_screen.dart';

import '../screens/exports/export_bindings.dart';
import '../screens/exports/export_screens.dart';

part 'routes_name.dart';

class RoutesClass {
  static final routes = [
    GetPage(
      name: RoutesName.pdfView,
      binding: PdfBinding(),
      page: () => const PdfViewScreen(),
      preventDuplicates: true,
    ),
    GetPage(
      name: RoutesName.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
      preventDuplicates: true,
    ),
    GetPage(
      name: RoutesName.newSale,
      page: () => const NewSaleScreen(),
      binding: NewSaleBinding(),
      preventDuplicates: true,
    ),
    GetPage(
      name: RoutesName.newOrder,
      page: () => const NewOrderScreen(),
      binding: NewOrderBinding(),
      preventDuplicates: true,
    ),
    GetPage(
      name: RoutesName.salesReturn,
      page: () => const SalesReturnScreen(),
      binding: SalesReturnBinding(),
      preventDuplicates: true,
    ),
    GetPage(
      name: RoutesName.customers,
      page: () => const CustomersScreen(),
      binding: CustomersBinding(),
      preventDuplicates: true,
    ),
    GetPage(
      name: RoutesName.addCustomer,
      page: () => const AddCustomerScreen(),
      binding: AddCustomerBinding(),
      preventDuplicates: true,
    ),
    GetPage(
      name: RoutesName.selectCustomer,
      page: () => const SelectCustomersScreen(),
      binding: SelectCustomerBinding(),
      preventDuplicates: true,
    ),
    GetPage(
      name: RoutesName.stockTransfer,
      page: () => const StockTransferScreen(),
      binding: StockTransferBinding(),
      preventDuplicates: true,
    ),
    GetPage(
      name: RoutesName.settings,
      page: () => const SettingsScreen(),
      binding: SettingsBinding(),
      preventDuplicates: true,
    ),
    GetPage(
      name: RoutesName.printersPreview,
      page: () => const PrintersPreview(),
      binding: PrintersBinding(),
      preventDuplicates: true,
    ),
    GetPage(
      name: RoutesName.register,
      page: () => const RegisterScreen(),
      binding: RegisterBinding(),
      preventDuplicates: true,
    ),
    GetPage(
      name: RoutesName.dashboard,
      page: () => const DashboardScreen(),
      binding: DashBoardBinding(),
      preventDuplicates: true,
    ),
    GetPage(
      name: RoutesName.paymentVoucher,
      page: () => const PaymentVoucherScreen(),
      binding: PaymentVoucherBinding(),
      preventDuplicates: true,
    ),
    GetPage(
      name: RoutesName.receiptVoucher,
      page: () => const ReceiptVoucherScreen(),
      binding: ReceiptVoucherBinding(),
      preventDuplicates: true,
    ),
    GetPage(
      name: RoutesName.vouchers,
      page: () => const VouchersScreen(),
      binding: VouchersBinding(),
      preventDuplicates: true,
    ),
    GetPage(
      name: RoutesName.itemWiseReport,
      page: () => const ItemWiseReportScreen(),
      binding: ItemWiseReportBinding(),
      preventDuplicates: true,
    ),
    GetPage(
      name: RoutesName.stocks,
      page: () => const FullStockScreen(),
      binding: FullStockBinding(),
      preventDuplicates: true,
    ),
    GetPage(
      name: RoutesName.customerAccount,
      page: () => const CustomerAccountScreen(),
      binding: CustomerAccountBinding(),
      preventDuplicates: true,
    ),
    GetPage(
      name: RoutesName.sync,
      page: () => const SyncScreen(),
      binding: SyncBinding(),
      preventDuplicates: true,
    ),
    GetPage(
      name: RoutesName.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
      preventDuplicates: true,
    ),
  ];
}
