import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/constants/app_style.dart';
import 'package:ozone_erp/models/menu_item.dart';
import 'package:ozone_erp/screens/settings/controller/settings_controller.dart';
import 'package:ozone_erp/screens/settings/widgets/category_tile.dart';

class DisableCategories extends StatelessWidget {
  const DisableCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        Get.find<SettingsController>().updateDisabledCategories();
        Get.back();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Disable Categories'),
          leading: IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon:Icon(Icons.arrow_back_ios_new_outlined)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Disabled Categories',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 15,
                ),
                GetBuilder<SettingsController>(
                  builder: (controller) {
                    return controller.disabledCategories.isEmpty
                        ? Container(
                            alignment: Alignment.center,
                            child: const Text(
                              'No categories disabled',
                              style: TextStyle(color: Colors.red),
                            ))
                        : Container();
                  },
                ),
                GetBuilder<SettingsController>(
                  builder: (controller) {
                    return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) => const SizedBox(
                              height: 15,
                            ),
                        itemBuilder: (context, index) {
                          return CategoryTile(
                            category: controller.disabledCategories[index],
                            color: Colors.red,
                            onTap: () {
                              controller.addDisableCategories(
                                  controller.disabledCategories[index]);
                            },
                          );
                        },
                        itemCount: controller.disabledCategories.length);
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                const Text(
                  'Enabled Categories',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                GetBuilder<SettingsController>(
                  builder: (controller) {
                    List<MenuItem> enabledCategories = controller.items
                        .where((element) =>
                            !controller.disabledCategories.contains(element))
                        .toList();
                    return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) => const SizedBox(
                              height: 15,
                            ),
                        itemBuilder: (context, index) {
                          return CategoryTile(
                            category: enabledCategories[index],
                            color: AppStyle.radioColor,
                            onTap: () {
                              controller.addDisableCategories(
                                  enabledCategories[index]);
                            },
                          );
                        },
                        itemCount: enabledCategories.length);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
