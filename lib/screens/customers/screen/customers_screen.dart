import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/constants/constant.dart';
import 'package:ozone_erp/routes/routes_class.dart';
import 'package:ozone_erp/screens/customers/controller/customers_controller.dart';
import 'package:ozone_erp/widgets/customer_details_view.dart';
import 'package:ozone_erp/widgets/customer_tile.dart';
import 'package:ozone_erp/widgets/no_outline_text_field.dart';
import 'package:ozone_erp/widgets/open_item.dart';

import '../../../components/export_components.dart';

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomersView();
  }
}

class CustomersView extends GetView<CustomersController> {
  const CustomersView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomersController>(builder: (control) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            if (controller.isSearching.value) {
              controller.isSearching(false);
            } else {
              Get.offNamed(Get.previousRoute);
            }
          }
        },
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: Obx(
                    () => controller.isSearching.value
                    ? AppBar(
                  backgroundColor: AppStyle.primaryColor,
                  leading: IconButton(
                      onPressed: () {
                        controller.search();
                      },
                      icon: const Icon(CupertinoIcons.back)),
                  title: NoOutlineTextField(
                    autofocus: true,
                    controller: controller.searchController,
                    hintText: 'Search...',
                    onChanged: controller.filterCustomers,
                  ),
                )
                    : customAppBar(
                    title: 'Customers',
                    actions: [
                      IconButton(
                          onPressed: () {
                            controller.search();
                          },
                          icon: const Icon(CupertinoIcons.search))
                    ],
                    whiteIcon: true),
              )),
          drawer: const CustomMenu(),
          body: RefreshIndicator(
            onRefresh: () async {
              await controller.getCustomers();
              await Future.delayed(const Duration(seconds: 1));
            },
            child: GetBuilder<CustomersController>(builder: (ctrl) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: DropdownMenu(
                      key: controller.dropKey,
                      dropdownMenuEntries: [
                        DropdownMenuEntry(value: '-1', label: 'All'),
                        ...controller.areas.map(
                              (e) {
                            return DropdownMenuEntry(
                                value: e.id, label: e.area ?? '');
                          },
                        )
                      ],
                      onSelected: (value) => ctrl.filterByArea(value!),
                      hintText: 'Select Area to filter',
                      width: double.infinity,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: ctrl.filteredCustomers.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OpenItem(
                              openChild: CustomerDetailsView(
                                customer: ctrl.filteredCustomers[index],
                                onLocationUpdate:
                                    (double latitude, double longitude) {
                                  ctrl.updateCustomerLocation(
                                    customer: ctrl.filteredCustomers[index],
                                    latitude: latitude,
                                    longitude: longitude,
                                  );
                                  ctrl.filteredCustomers[index] =
                                      ctrl.filteredCustomers[index].copyWith(
                                          latitude: latitude.toString(),
                                          longitude: longitude.toString());
                                  ctrl.update();
                                },
                              ),
                              closedChild: CustomerTile(
                                  customer: ctrl.filteredCustomers[index])),
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final customer = await Get.toNamed(RoutesName.addCustomer);
              if (customer != null) {
                controller.customers.insert(0, customer);
                controller.filteredCustomers = controller.customers;
                controller.update();
              }
            },
            backgroundColor: AppStyle.floatingActionColor,
            foregroundColor: AppStyle.primaryColor,
            child: const Icon(CupertinoIcons.add),
          ),
        ),
      );
    });
  }
}