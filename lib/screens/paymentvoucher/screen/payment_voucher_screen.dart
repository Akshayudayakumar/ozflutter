import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/components/custom_app_bar.dart';
import 'package:ozone_erp/components/custom_menu.dart';
import 'package:ozone_erp/constants/constant.dart';
import 'package:ozone_erp/models/general_details.dart';
import 'package:ozone_erp/screens/paymentvoucher/controller/payment_voucher_controller.dart';
import 'package:ozone_erp/widgets/custom_text_field.dart';
import 'package:ozone_erp/widgets/pop/pop_blocker.dart';
import 'package:ozone_erp/widgets/solid_button.dart';

import '../../../models/state_model.dart';
import '../../../utils/decimal_text_formatter.dart';

class PaymentVoucherScreen extends StatelessWidget {
  const PaymentVoucherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Payment Voucher', centerTitle: true),
      drawer: const CustomMenu(),
      body: const PaymentVoucherView(),
    );
  }
}

class PaymentVoucherView extends GetView<PaymentVoucherController> {
  const PaymentVoucherView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopBlocker(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(SizeConstant.screenWidth * .03),
          child: Form(
            key: controller.formKey,
            child: ListView(
              children: [
                Row(
                  children: [
                    Expanded(flex: 1, child: Text('Date:')),
                    Expanded(
                        flex: 2,
                        child: CustomTextField(
                            controller: controller.dateController,
                            readOnly: true,
                            onTap: () async {
                              await controller.updateDate();
                            },
                            hintText: 'Date',
                            type: 'date')),
                  ],
                ),
                Row(
                  children: [
                    Expanded(flex: 1, child: Text('To Account:')),
                    Expanded(
                        flex: 2,
                        child: TypeAheadField(
                          controller: controller.toAccount,
                          hideOnEmpty: true,
                          itemBuilder: (context, value) {
                            return ListTile(
                              title: Text(value.name!),
                            );
                          },
                          builder: (context, controller, focusNode) {
                            return CustomTextField(
                                controller: controller,
                                focusNode: focusNode,
                                hintText: 'To Account',
                                validator: (value) {
                                  final paymentController =
                                      Get.find<PaymentVoucherController>();
                                  if (value!.trim().isEmpty) {
                                    return 'From Account Required';
                                  } else if (paymentController
                                          .selectedCustomer.value.id ==
                                      null) {
                                    return 'Customer not selected';
                                  }
                                  return null;
                                },
                                type: 'account');
                            //   TextField(
                            //   controller: controller,
                            //   focusNode: focusNode,
                            //   style:
                            //   const TextStyle(fontSize: 14),
                            //   decoration: const InputDecoration(
                            //     hintText: 'Add Item',
                            //     border: OutlineInputBorder(
                            //       borderSide: BorderSide(
                            //           color: Colors.transparent),
                            //     ),
                            //     focusedBorder: OutlineInputBorder(
                            //       borderSide: BorderSide(
                            //           color: Colors.transparent),
                            //     ),
                            //     enabledBorder: OutlineInputBorder(
                            //       borderSide: BorderSide(
                            //           color: Colors.transparent),
                            //     ),
                            //     errorBorder: OutlineInputBorder(
                            //       borderSide: BorderSide(
                            //           color: Colors.transparent),
                            //     ),
                            //     disabledBorder:
                            //     OutlineInputBorder(
                            //       borderSide: BorderSide(
                            //           color: Colors.transparent),
                            //     ),
                            //     contentPadding:
                            //     EdgeInsets.symmetric(
                            //         vertical: 0,
                            //         horizontal: 10),
                            //   ),
                            // );
                          },
                          onSelected: (value) {
                            controller.selectedCustomer(value);
                            controller.toAccount.text = value.name ?? '';
                          },
                          suggestionsCallback: (search) {
                            if (search.isEmpty) {
                              return <Customers>[];
                            }
                            return controller.customers
                                .where((item) => (item.name ?? '')
                                    .toLowerCase()
                                    .contains(search.trim().toLowerCase()))
                                .toList();
                          },
                        )),
                  ],
                ),
                Obx(
                  () {
                    return controller.selectedCustomer.value.creditAmount ==
                            null
                        ? const SizedBox()
                        : Row(
                            children: [
                              const Expanded(flex: 1, child: SizedBox()),
                              Expanded(
                                  child: Text(
                                      '${controller.selectedCustomer.value.creditAmount ?? '0'} Cr')),
                            ],
                          );
                  },
                ),
                Row(
                  children: [
                    Expanded(flex: 1, child: Text('Narration:')),
                    Expanded(
                        flex: 2,
                        child: CustomTextField(
                            controller: controller.narration,
                            maxLines: 5,
                            validator: (value) => value!.trim().isEmpty
                                ? 'Narration Required'
                                : null,
                            hintText: 'Narration',
                            type: 'narration')),
                  ],
                ),
                Row(
                  children: [
                    Expanded(flex: 1, child: Text('Amount:')),
                    Expanded(
                        flex: 2,
                        child: CustomTextField(
                            controller: controller.amount,
                            validator: (value) => value!.trim().isEmpty
                                ? 'Amount Required'
                                : null,
                            textInputType: TextInputType.numberWithOptions(
                                decimal: true, signed: false),
                            inputFormatters: [
                              DecimalInputFormatter(),
                            ],
                            hintText: 'Amount',
                            type: 'amount')),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SolidButton(
                      height: SizeConstant.screenHeight * .05,
                      onTap: () async => await controller.save(),
                      width: SizeConstant.screenWidth * .3,
                      curveRadius: SizeConstant.screenHeight * .01,
                      color: AppStyle.radioColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'SAVE',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SolidButton(
                      onTap: () {
                        if (controller.hasPreviousPage) {
                          Get.back();
                        } else {
                          Get.offNamed(controller.previousRoute);
                        }
                      },
                      height: SizeConstant.screenHeight * .05,
                      width: SizeConstant.screenWidth * .3,
                      curveRadius: SizeConstant.screenHeight * .01,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'CANCEL',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: SizeConstant.screenHeight * .05,
                ),
                Obx(
                  () {
                    switch (controller.state.value) {
                      case StateModel.loading:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      case StateModel.success:
                        return const SizedBox();
                      case StateModel.error:
                        return Center(
                          child: Text(controller.errorMessage.value),
                        );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
