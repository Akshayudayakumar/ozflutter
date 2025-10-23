import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/Constants/constant.dart';
import 'package:ozone_erp/components/custom_app_bar.dart';
import 'package:ozone_erp/screens/customers/subScreen/controller/add_customer_controller.dart';
import 'package:ozone_erp/widgets/export_widgets.dart';
import '../../../../models/state_model.dart';

class AddCustomerScreen extends StatelessWidget {
  const AddCustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(title: 'Add New Customer', centerTitle: true),
        body: const AddCustomerView());
  }
}

class AddCustomerView extends GetView<AddCustomerController> {
  const AddCustomerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
            () {
          switch (controller.state.value) {
            case StateModel.loading:
              return const Center(child: CircularProgressIndicator());
            case StateModel.error:
              return const SizedBox();
            case StateModel.success:
              return ListView(
                padding:
                EdgeInsets.only(bottom: SizeConstant.percentToHeight(10)),
                children: [
                  Form(
                      key: controller.formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                              controller: controller.nameController,
                              textInputType: TextInputType.name,
                              textCapitalization: TextCapitalization.words,
                              validator: (value) =>
                              value!.isEmpty ? 'Enter Name' : null,
                              hintText: 'Enter Name',
                              type: 'Name'),
                          CustomTextField(
                              controller: controller.phoneController,
                              textInputType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) =>
                              value!.isEmpty ? 'Enter Phone Number' : null,
                              hintText: 'Enter Phone Number',
                              type: 'Phone Number'),
                          CustomTextField(
                            controller: controller.addressController,
                            textInputType: TextInputType.streetAddress,
                            hintText: 'Enter Address',
                            type: 'Address',
                            maxLines: 5,
                            minLines: 5,
                          ),
                          CustomTextField(
                              controller: controller.gstController,
                              hintText: 'Enter GST No.',
                              type: 'GST'),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: DropdownMenu(
                              label: TextWidget('Type'),
                              dropdownMenuEntries: [
                                ...controller.customerTypes.map(
                                      (e) {
                                    return DropdownMenuEntry(
                                        value: e.id, label: e.name);
                                  },
                                )
                              ],
                              onSelected: (value) =>
                                  controller.selectCustomerType(value!),
                              hintText: 'Select Customer Type',
                              width: double.infinity,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Obx(() {
                              return DropdownMenu(
                                initialSelection: '0',
                                label: TextWidget('Area'),
                                dropdownMenuEntries: [
                                  DropdownMenuEntry(value: '0', label: 'All'),
                                  ...controller.areas.map(
                                        (e) {
                                      return DropdownMenuEntry(
                                          value: e.id, label: e.area ?? '');
                                    },
                                  )
                                ],
                                onSelected: (value) =>
                                    controller.selectArea(value!),
                                hintText: 'Select Area to filter',
                                width: double.infinity,
                              );
                            }),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Obx(() {
                              return DropdownMenu(
                                initialSelection: '0',
                                label: TextWidget('Price List'),
                                dropdownMenuEntries: [
                                  DropdownMenuEntry(value: '0', label: 'All'),
                                  ...controller.priceLists.map(
                                        (e) {
                                      return DropdownMenuEntry(
                                          value: e.id,
                                          label: e.priceList ?? '');
                                    },
                                  )
                                ],
                                onSelected: (value) =>
                                    controller.selectPriceList(value!),
                                hintText: 'Select Price List',
                                width: double.infinity,
                              );
                            }),
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 16,
                  ),
                  Obx(
                        () {
                      switch (controller.submitState.value) {
                        case StateModel.loading:
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        case StateModel.success:
                          return const SizedBox.shrink();
                        case StateModel.error:
                          return Center(
                            child: TextWidget(
                              controller.errorMessage.value,
                              color: Colors.red,
                              bold: true,
                            ),
                          );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  PrintButton(
                    onTap: () {
                      controller.addCustomer();
                    },
                    child: Obx(() {
                      bool failure =
                          controller.submitState.value == StateModel.error;
                      return Text(
                        failure ? 'Retry' : 'Add Customer',
                        style: TextStyle(color: Colors.white),
                      );
                    }),
                  )
                ],
              );
          }
        },
      ),
    );
  }
}