import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/components/custom_app_bar.dart';
import 'package:ozone_erp/components/custom_menu.dart';
import 'package:ozone_erp/screens/vouchers/controller/vouchers_controller.dart';
import 'package:ozone_erp/screens/vouchers/widgets/vouchers_table.dart';
import 'package:ozone_erp/services/pdf_services.dart';
import 'package:ozone_erp/widgets/pop/pop_blocker.dart';

import '../../../constants/constant.dart';
import '../../../widgets/export_widgets.dart';

class VouchersScreen extends StatefulWidget {
  const VouchersScreen({super.key});

  @override
  State<VouchersScreen> createState() => _VouchersScreenState();
}

class _VouchersScreenState extends State<VouchersScreen>
    with TickerProviderStateMixin {
  TabController? controller;

  @override
  void initState() {
    controller = TabController(length: 2, vsync: this);
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopBlocker(
      child: Scaffold(
        appBar: customAppBar(
          title: 'Vouchers',
          tabBar: TabBar(
            controller: controller,
            indicatorSize: TabBarIndicatorSize.label,
            unselectedLabelColor: Colors.white60,
            labelColor: Colors.black,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50), color: Colors.white),
            tabs: [
              Tab(
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConstant.screenWidth * .05),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(50)),
                  child: const FittedBox(
                    child: Text("Payment Vouchers"),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConstant.screenWidth * .05),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(50)),
                  child: const FittedBox(
                    child: Text("Receipt Vouchers"),
                  ),
                ),
              ),
            ],
            indicatorPadding: EdgeInsets.symmetric(
                vertical: SizeConstant.screenHeight * .008),
          ),
        ),
        drawer: const CustomMenu(),
        body: TabBarView(controller: controller, children: const [
          PaymentVouchersView(),
          ReceiptVouchersView(),
        ]),
      ),
    );
  }
}

class PaymentVouchersView extends GetView<VouchersController> {
  const PaymentVouchersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder(builder: (VouchersController controller) {
        return VouchersTable(
          vouchers: controller.paymentVouchers,
          getCustomer: (id) => controller.getCustomer(id).name ?? '',
        );
      }),
      floatingActionButton: ActionWidget(
        onTap: () {
          controller.showPrintMethod(
              receiptType: 'Payment Vouchers',
              printAll: () => PdfServices().printVouchers(
                    [
                      ...controller.paymentVouchers,
                      ...controller.receiptVouchers
                    ],
                    (id) => controller.getCustomer(id).name ?? '',
                  ),
              printOnly: () => PdfServices().printVouchers(
                    controller.paymentVouchers,
                    (id) => controller.getCustomer(id).name ?? '',
                  ));
        },
        opacity: 20,
        height: 50,
        width: 50,
        iconSize: 20,
        color: AppStyle.radioColor,
        icon: Icons.print,
      ),
    );
  }
}

class ReceiptVouchersView extends GetView<VouchersController> {
  const ReceiptVouchersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder(builder: (VouchersController controller) {
        return VouchersTable(
          vouchers: controller.receiptVouchers,
          getCustomer: (id) => controller.getCustomer(id).name ?? '',
        );
      }),
      floatingActionButton: ActionWidget(
        onTap: () {
          controller.showPrintMethod(
              receiptType: 'Receipt Vouchers',
              printAll: () => PdfServices().printVouchers(
                    [
                      ...controller.paymentVouchers,
                      ...controller.receiptVouchers
                    ],
                    (id) => controller.getCustomer(id).name ?? '',
                  ),
              printOnly: () => PdfServices().printVouchers(
                    controller.receiptVouchers,
                    (id) => controller.getCustomer(id).name ?? '',
                  ));
        },
        opacity: 20,
        height: 50,
        width: 50,
        iconSize: 20,
        color: AppStyle.radioColor,
        icon: Icons.print,
      ),
    );
  }
}
