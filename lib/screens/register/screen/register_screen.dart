import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/components/custom_app_bar.dart';
import 'package:ozone_erp/components/custom_menu.dart';
import 'package:ozone_erp/database/tables/export_insert.dart';
import 'package:ozone_erp/screens/register/controller/register_controller.dart';
import 'package:ozone_erp/screens/sync/controller/sync_controller.dart';
import 'package:ozone_erp/widgets/pop/pop_blocker.dart';

import '../../../constants/constant.dart';
import '../../../services/pdf_services.dart';
import '../../../widgets/export_widgets.dart';
import '../../../widgets/show_pdf.dart';
import 'export_reports.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  TabController? controller;

  @override
  void initState() {
    controller = TabController(length: 4, vsync: this);
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopBlocker(
      child: Scaffold(
        appBar: customAppBar(
            title: 'Register',
            style: FontConstant.inter.copyWith(
                color: AppStyle.tabColor,
                fontWeight: FontWeight.bold,
                fontSize: SizeConstant.font14),
            color: Colors.white,
            sync: () async {
              await Get.put(SyncController()).saveSync(SyncTypes.sale);
              await Get.put(SyncController()).saveSync(SyncTypes.order);
              await Get.put(SyncController()).saveSync(SyncTypes.salesReturn);
              final controller = Get.find<RegisterController>();
              await controller.getAllItems();
              await controller.getSalesBody();
            },
            refresh: () async {
              final controller = Get.find<RegisterController>();
              await controller.getAllItems();
              await controller.getSalesBody();
            },
            tabBar: TabBar(
              controller: controller,
              isScrollable: true,
              tabs: [
                Tab(
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConstant.screenWidth * .05),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(50)),
                    child: const Text("Sales Report"),
                  ),
                ),
                Tab(
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConstant.screenWidth * .05),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(50)),
                    child: const Text("Order Report"),
                  ),
                ),
                Tab(
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConstant.screenWidth * .05),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(50)),
                    child: const Text("Sales Return Report"),
                  ),
                ),
                Tab(
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConstant.screenWidth * .05),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(50)),
                    child: const Text("Payment Report"),
                  ),
                ),
                // Tab(
                //   child: Container(
                //     alignment: Alignment.center,
                //     padding: EdgeInsets.symmetric(
                //         horizontal: SizeConstant.screenWidth * .05),
                //     decoration:
                //         BoxDecoration(borderRadius: BorderRadius.circular(50)),
                //     child: const Text("Item Wise Report"),
                //   ),
                // ),
              ],
              indicatorPadding: EdgeInsets.symmetric(
                  vertical: SizeConstant.screenHeight * .008),
            ),
            iconTheme: const IconThemeData(color: AppStyle.tabColor)),
        drawer: const CustomMenu(),
        floatingActionButton: ActionWidget(
          color: AppStyle.radioColor,
          onTap: () async {
            final sales = await InsertSalesBody().getSalesBody();
            final pdf = await PdfServices().generateRegisterPdf(sales);
            Get.to(() => ShowPdf(
                  title: 'Sales Register',
                  pdf: pdf,
                ));
          },
          icon: Icons.print,
          iconSize: 24,
        ),
        body: TabBarView(controller: controller, children: const [
          SalesReport(),
          OrderReport(),
          SalesReturnReport(),
          PaymentReport(),
          // ItemWiseReport(),
        ]),
      ),
    );
  }
}
