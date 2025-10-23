
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/constants/constant.dart';
import 'package:ozone_erp/routes/routes_class.dart';
import 'package:ozone_erp/screens/customers/selectCustomer/controller/select_customer_controller.dart';
import 'package:ozone_erp/screens/neworder/controller/new_order_controller.dart';
import 'package:ozone_erp/screens/newsale/controller/new_sale_controller.dart';
import 'package:ozone_erp/utils/utils.dart';
import 'package:ozone_erp/widgets/customer_tile.dart';
import 'package:ozone_erp/widgets/no_outline_text_field.dart';

import '../../../../components/export_components.dart';
import '../../../salesreturn/controller/sales_return_controller.dart';

class SelectCustomersScreen extends StatelessWidget {
  const SelectCustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SelectCustomersView();
  }
}

class SelectCustomersView extends GetView<SelectCustomersController> {
  const SelectCustomersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Obx(
            () => controller.isSearching.value
                ? AppBar(
                    backgroundColor: AppStyle.primaryColor.withOpacity(0.1),
                    leading: IconButton(
                        onPressed: () {
                          controller.search();
                        },
                        icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                    title: NoOutlineTextField(
                      controller: controller.searchController,
                      autofocus: true,
                      hintText: 'Search...',
                      onChanged: controller.filterCustomers,
                    ),
                  )
                : customAppBar(
                    title: 'Customers',
                    actions: [
                      // This IconButton serves as the search icon.
                      IconButton(
                          // When pressed, it calls the `search()` method on the controller.
                          // This method likely toggles the `isSearching` boolean value,
                          // which causes this Obx widget to rebuild.
                          onPressed: () {
                            controller.search();
                          },
                          // The icon displayed is a standard search magnifying glass.
                          icon: const Icon(Icons.search))
                    ],
                    // This part of the code defines the default appearance of the AppBar
                    // when `controller.isSearching.value` is `false`.
                    // It displays a custom AppBar with the title 'Customers' and a search
                    // icon as an action button. Tapping the search icon switches the UI
                    // to the search mode, showing the search input field instead of the title.
                    whiteIcon: true), // `whiteIcon` is likely a custom property to style the AppBar icons.
          )),
      body: GetBuilder<SelectCustomersController>(builder: (ctrl) {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: ctrl.filteredCustomers.length,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                itemBuilder: (context, index) {
                  final customer = ctrl.filteredCustomers[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Material(
                      elevation: 1.5,
                      shadowColor: Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15.0),
                        onTap: () {
                          dynamic c;
                          if (Get.isRegistered<NewSaleController>()) {
                            c = Get.find<NewSaleController>();
                          } else if (Get.isRegistered<NewOrderController>()) {
                            c = Get.find<NewOrderController>();
                          } else if (Get.isRegistered<SalesReturnController>()) {
                            c = Get.find<SalesReturnController>();
                          }
                          if (c != null) {
                            Get.back();
                            c.selectCustomer(customer);
                            c.addLocation();
                          } else {
                            Utils().showToast('Something went wrong');
                          }
                        },
                        child: CustomerTile(customer: customer,
                          isCard: true,
                        )
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(RoutesName.addCustomer);
        },
        backgroundColor: AppStyle.primaryColor,
        foregroundColor: AppStyle.whiteColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
