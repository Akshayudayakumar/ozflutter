import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/Constants/constant.dart';
import 'package:ozone_erp/data/app_data.dart';
import 'package:ozone_erp/screens/settings/controller/settings_controller.dart';
import 'package:ozone_erp/screens/settings/widgets/disable_categories.dart';
import 'package:ozone_erp/widgets/pop/pop_blocker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../components/export_components.dart';
import '../../../models/menu_item.dart';
import '../../../widgets/export_widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Settings'),
      drawer: const CustomMenu(),
      body: const SettingsView(),
    );
  }
}

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopBlocker(
      child: Scaffold(
        body: GetBuilder<SettingsController>(builder: (controller) {
          List<MenuItem> enabledCategories = controller.items
              .where(
                  (element) => !controller.disabledCategories.contains(element))
              .toList();
          return ListView(
            children: [
              const OpenItem(
                openChild: DisableCategories(),
                closedChild: ListTile(
                  title: Text('Enable / Disable Categories'),
                  subtitle: Text(
                      'Disable categories you don\'t want to see in the app.'),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                child: TextWidget(
                  'View',
                  style: FontConstant.interLargeBold,
                ),
              ),
              ListTile(
                title: const TextWidget(
                  'Default Startup Page',
                  maxLines: 2,
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownMenu(
                    initialSelection: AppData()
                            .getDisabledMenuItems()
                            .contains(AppData().getInitialRoute())
                        ? '-1'
                        : AppData().getInitialRoute(),
                    dropdownMenuEntries: [
                      DropdownMenuEntry(value: '-1', label: 'None'),
                      ...enabledCategories
                          .map(
                            (e) =>
                                DropdownMenuEntry(value: e.id, label: e.title),
                          )
                          .toList(),
                    ],
                    width: double.infinity,
                    onSelected: (value) => AppData().storeInitialRoute(value!),
                  ),
                ),
              ),
              // ListTile(
              //   title: const TextWidget(
              //     'Show multiple Rate on item dialog',
              //   ),
              //   trailing: Switch(
              //       value: controller.multipleRate,
              //       onChanged: (value) {
              //         controller.multipleRate = value;
              //         controller.update();
              //       }),
              // ),
              // ListTile(
              //   title: const TextWidget(
              //     'Tax View on item dialog',
              //   ),
              //   trailing: Switch(
              //       value: controller.taxView,
              //       onChanged: (value) {
              //         controller.taxView = value;
              //         controller.update();
              //       }),
              // ),
              // ListTile(
              //   title: const TextWidget(
              //     'CES View on item dialog',
              //   ),
              //   trailing: Switch(
              //       value: controller.cesView,
              //       onChanged: (value) {
              //         controller.cesView = value;
              //         controller.update();
              //       }),
              // ),
              // ListTile(
              //   title: const TextWidget(
              //     'Sales Return Mode',
              //   ),
              //   trailing: Switch(
              //       value: controller.returnMode,
              //       onChanged: (value) {
              //         controller.returnMode = value;
              //         controller.update();
              //       }),
              // ),
              // ListTile(
              //   title: const TextWidget(
              //     'Customer Balance View on Bill',
              //   ),
              //   trailing: Switch(
              //       value: controller.balanceView,
              //       onChanged: (value) {
              //         controller.balanceView = value;
              //         controller.update();
              //       }),
              // ),
              // ListTile(
              //   title: const TextWidget(
              //     'Address View on Bill',
              //   ),
              //   trailing: Switch(
              //       value: controller.addressView,
              //       onChanged: (value) {
              //         controller.addressView = value;
              //         controller.update();
              //       }),
              // ),
              // ListTile(
              //   title: const TextWidget(
              //     'Current stock view on item dialog',
              //   ),
              //   trailing: Switch(
              //       value: controller.currentStockView,
              //       onChanged: (value) {
              //         controller.currentStockView = value;
              //         controller.update();
              //       }),
              // ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                child: TextWidget(
                  'General',
                  style: FontConstant.interLargeBold,
                ),
              ),
              ListTile(
                title: const TextWidget(
                  'Free Quantity',
                ),
                trailing: Switch(
                    value: controller.freeQuantity,
                    onChanged: (value) {
                      controller.freeQuantity = value;
                      AppData().storeFreeQuantity(value);
                      controller.update();
                    }),
              ),
              ListTile(
                title: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: const TextWidget('Default Currency Selection')),
                trailing: DropdownMenu(
                  textAlign: TextAlign.end,
                  initialSelection: controller.currency,
                  dropdownMenuEntries: controller.currencies
                      .map((e) => DropdownMenuEntry(
                          value: e.id,
                          label: e.code!,
                          labelWidget: TextWidget(e.name!)))
                      .toList(),
                  width: SizeConstant.screenWidth * .3,
                  onSelected: (value) => controller.currency = value!,
                  inputDecorationTheme:
                      InputDecorationTheme(border: InputBorder.none),
                ),
              ),
              ListTile(
                title: const TextWidget(
                  'Send SMS',
                ),
                trailing: Switch(
                    value: controller.sendSMS,
                    onChanged: (value) async {
                      if (await Permission.sms.request().isDenied) return;
                      if (await Permission.sms.isPermanentlyDenied) return;
                      if (await Permission.sms.isRestricted) return;
                      controller.sendSMS = value;
                      controller.update();
                    }),
              ),
              // ListTile(
              //   title: const TextWidget('Default Sim'),
              //   trailing: SizedBox(
              //     width: SizeConstant.percentToWidth(40),
              //     child: FittedBox(
              //         fit: BoxFit.scaleDown,
              //         child: Row(
              //           children: [
              //             Radio(
              //                 value: 'sim1',
              //                 activeColor: AppStyle.radioColor,
              //                 groupValue: controller.selectedSim,
              //                 onChanged: (value) {
              //                   controller.selectedSim = value!;
              //                   controller.update();
              //                 }),
              //             const TextWidget('Sim 1'),
              //             Radio(
              //                 value: 'sim2',
              //                 groupValue: controller.selectedSim,
              //                 activeColor: AppStyle.radioColor,
              //                 onChanged: (value) {
              //                   controller.selectedSim = value!;
              //                   controller.update();
              //                 }),
              //             const TextWidget('Sim 2'),
              //           ],
              //         )),
              //   ),
              // ),
              ListTile(
                title: const TextWidget(
                  'Sync on Save',
                ),
                trailing: Switch(
                    value: controller.syncOnSave,
                    onChanged: (value) {
                      controller.syncOnSave = value;
                      controller.update();
                    }),
              ),
              // ListTile(
              //   title: const TextWidget(
              //     'Enable redeem',
              //   ),
              //   trailing: Switch(
              //       value: controller.redeem,
              //       onChanged: (value) {
              //         controller.redeem = value;
              //         controller.update();
              //       }),
              // ),
              // ListTile(
              //   title: const TextWidget(
              //     'Item repeat mode',
              //   ),
              //   trailing: Switch(
              //       value: controller.itemRepeat,
              //       onChanged: (value) {
              //         controller.itemRepeat = value;
              //         controller.update();
              //       }),
              // ),
              ListTile(
                title: const TextWidget('Default Cash Type'),
                trailing: SizedBox(
                  width: SizeConstant.percentToWidth(40),
                  child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        children: [
                          Radio(
                              value: 'Cash',
                              activeColor: AppStyle.radioColor,
                              groupValue: controller.cashType,
                              onChanged: (value) {
                                controller.cashType = value!;
                                controller.update();
                              }),
                          const TextWidget('Cash'),
                          Radio(
                              value: 'Credit',
                              groupValue: controller.cashType,
                              activeColor: AppStyle.radioColor,
                              onChanged: (value) {
                                controller.cashType = value!;
                                controller.update();
                              }),
                          const TextWidget('Credit'),
                          Radio(
                              value: 'Bank',
                              groupValue: controller.cashType,
                              activeColor: AppStyle.radioColor,
                              onChanged: (value) {
                                controller.cashType = value!;
                                controller.update();
                              }),
                          const TextWidget('Bank'),
                        ],
                      )),
                ),
              ),
              // ListTile(
              //   title: const TextWidget(
              //     'Bill Discount View',
              //   ),
              //   trailing: Switch(
              //       value: controller.billDiscount,
              //       onChanged: (value) {
              //         controller.billDiscount = value;
              //         controller.update();
              //       }),
              // ),
              // ListTile(
              //   title: const TextWidget(
              //     'Collection Amount View',
              //   ),
              //   trailing: Switch(
              //       value: controller.collectionAmount,
              //       onChanged: (value) {
              //         controller.collectionAmount = value;
              //         controller.update();
              //       }),
              // ),
              ListTile(
                title: const TextWidget('Default Quantity'),
                subtitle: TextFormField(
                  initialValue: controller.defaultQuantity,
                  onChanged: (value) => controller.defaultQuantity = value,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    NoLeadingZeroFormatter()
                  ],
                ),
              ),
              ListTile(
                title: const TextWidget('Increment Quantity'),
                subtitle: TextFormField(
                  initialValue: controller.incrementQuantity,
                  onChanged: (value) => controller.incrementQuantity = value,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    NoLeadingZeroFormatter()
                  ],
                ),
              ),
              ListTile(
                title: const TextWidget('Send Log'),
                trailing: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: SolidButton(
                    onTap: () {},
                    child: const TextWidget(
                      'SEND',
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    curveRadius: 4,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                child: TextWidget(
                  'Thermal Print',
                  style: FontConstant.interLargeBold,
                ),
              ),
              ListTile(
                title: const TextWidget('Paper Size'),
                trailing: SizedBox(
                  width: SizeConstant.percentToWidth(50),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      children: [
                        Radio(
                            value: '2',
                            activeColor: AppStyle.radioColor,
                            groupValue: controller.thermalPaper,
                            onChanged: (value) {
                              controller.thermalPaper = value!;
                              controller.update();
                            }),
                        const TextWidget('2 inch'),
                        Radio(
                            value: '2.5',
                            activeColor: AppStyle.radioColor,
                            groupValue: controller.thermalPaper,
                            onChanged: (value) {
                              controller.thermalPaper = value!;
                              controller.update();
                            }),
                        const TextWidget('2.5 inch'),
                        Radio(
                            value: '3',
                            groupValue: controller.thermalPaper,
                            activeColor: AppStyle.radioColor,
                            onChanged: (value) {
                              controller.thermalPaper = value!;
                              controller.update();
                            }),
                        const TextWidget('3 inch'),
                      ],
                    ),
                  ),
                ),
              ),
              ListTile(
                title: const TextWidget('Paper Size (in mm)'),
                trailing: SizedBox(
                  width: SizeConstant.percentToWidth(50),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      children: [
                        Radio(
                            value: '2',
                            activeColor: AppStyle.radioColor,
                            groupValue: controller.thermalPaper,
                            onChanged: (value) {
                              controller.thermalPaper = value!;
                              controller.update();
                            }),
                        const TextWidget('mm58'),
                        Radio(
                            value: '2.5',
                            activeColor: AppStyle.radioColor,
                            groupValue: controller.thermalPaper,
                            onChanged: (value) {
                              controller.thermalPaper = value!;
                              controller.update();
                            }),
                        const TextWidget('mm72'),
                        Radio(
                            value: '3',
                            groupValue: controller.thermalPaper,
                            activeColor: AppStyle.radioColor,
                            onChanged: (value) {
                              controller.thermalPaper = value!;
                              controller.update();
                            }),
                        const TextWidget('mm80'),
                      ],
                    ),
                  ),
                ),
              ),
              // ListTile(
              //   title: const TextWidget(
              //     'Print preview',
              //   ),
              //   trailing: Switch(
              //       value: controller.printPreview,
              //       onChanged: (value) {
              //         controller.printPreview = value;
              //         controller.update();
              //       }),
              // ),
              ListTile(
                title: const TextWidget(
                  'Print MRP View on 3 inch',
                ),
                trailing: Switch(
                    value: controller.printMRP,
                    onChanged: (value) {
                      controller.printMRP = value;
                      controller.update();
                    }),
              ),
              ListTile(
                title: const TextWidget(
                  'Print HSN code view',
                ),
                trailing: Switch(
                    value: controller.printHSN,
                    onChanged: (value) {
                      controller.printHSN = value;
                      controller.update();
                    }),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                child: TextWidget(
                  'PDF Print',
                  style: FontConstant.interLargeBold,
                ),
              ),
              ListTile(
                title: const TextWidget('Bill Format'),
                trailing: SizedBox(
                  width: SizeConstant.percentToWidth(40),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      children: [
                        Radio(
                            value: 'basic',
                            activeColor: AppStyle.radioColor,
                            groupValue: controller.billFormat,
                            onChanged: (value) {
                              controller.billFormat = value!;
                              controller.update();
                            }),
                        const TextWidget('Basic'),
                        Radio(
                            value: 'advanced',
                            groupValue: controller.billFormat,
                            activeColor: AppStyle.radioColor,
                            onChanged: (value) {
                              controller.billFormat = value!;
                              controller.update();
                            }),
                        const TextWidget('Advanced'),
                      ],
                    ),
                  ),
                ),
              ),
              ListTile(
                title: const TextWidget('Edit dialog Format'),
                trailing: SizedBox(
                  width: SizeConstant.percentToWidth(40),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      children: [
                        Radio(
                            value: 'basic',
                            activeColor: AppStyle.radioColor,
                            groupValue: controller.editDialog,
                            onChanged: (value) {
                              controller.editDialog = value!;
                              controller.update();
                            }),
                        const TextWidget('Basic'),
                        Radio(
                            value: 'advanced',
                            groupValue: controller.editDialog,
                            activeColor: AppStyle.radioColor,
                            onChanged: (value) {
                              controller.editDialog = value!;
                              controller.update();
                            }),
                        const TextWidget('Advanced'),
                      ],
                    ),
                  ),
                ),
              ),
              ListTile(
                title: const TextWidget('PDF Paper Size'),
                trailing: SizedBox(
                  width: SizeConstant.screenWidth * .5,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      children: [
                        Radio(
                            value: 'A3',
                            activeColor: AppStyle.radioColor,
                            groupValue: controller.pdfSize,
                            onChanged: (value) {
                              controller.pdfSize = value!;
                              controller.update();
                            }),
                        const TextWidget('A3'),
                        Radio(
                            value: 'A4',
                            groupValue: controller.pdfSize,
                            activeColor: AppStyle.radioColor,
                            onChanged: (value) {
                              controller.pdfSize = value!;
                              controller.update();
                            }),
                        const TextWidget('A4'),
                        Radio(
                            value: 'A5',
                            groupValue: controller.pdfSize,
                            activeColor: AppStyle.radioColor,
                            onChanged: (value) {
                              controller.pdfSize = value!;
                              controller.update();
                            }),
                        const TextWidget('A5'),
                        Radio(
                            value: 'A6',
                            groupValue: controller.pdfSize,
                            activeColor: AppStyle.radioColor,
                            onChanged: (value) {
                              controller.pdfSize = value!;
                              controller.update();
                            }),
                        const TextWidget('A6'),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: SizeConstant.percentToHeight(10),
              )
            ],
          );
        }),
      ),
    );
  }
}

///To Prevent numbers from starting with zero
class NoLeadingZeroFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Prevents numbers from starting with zero
    if (newValue.text.startsWith('0')) {
      return oldValue;
    }
    return newValue;
  }
}
