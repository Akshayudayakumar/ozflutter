import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/data/app_data.dart';
import 'package:ozone_erp/database/db_functions.dart';
import 'package:ozone_erp/models/menu_item.dart';
import 'package:ozone_erp/widgets/export_widgets.dart';

import '../constants/constant.dart';
import '../routes/routes_class.dart';
import '../widgets/loader/loading_widget.dart';
import 'menu_controller.dart';

// class CustomMenu extends GetView<CustomMenuController> {
//   const CustomMenu({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       backgroundColor: AppStyle.drawerColor,
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               width: double.infinity,
//               color: Colors.white, // header background color
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(
//                     height: 30,
//                   ),
//                   Container(
//                       height: 100,
//                       width: double.infinity,
//                       alignment: Alignment.center,
//                       child: CachedNetworkImage(
//                         imageUrl: BackEnd.logo,
//                         placeholder: (context, url) => const LoadingWidget(
//                           width: double.infinity,
//                           height: double.infinity,
//                         ),
//                         errorWidget: (context, url, error) =>
//                             Image.asset(AssetConstant.logo),
//                       )),
//                   const SizedBox(
//                     height: 30,
//                   ),
//                   Text(
//                     AppData().getCompanyName().toUpperCase(),
//                     style: FontConstant().drawerHeaderStyle,
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   GetBuilder<CustomMenuController>(builder: (controller) {
//                     return Text(controller.user?.userName.toString() ??
//                         AppData().getUserName());
//                   }),
//                   Obx(
//                     () => Text(controller.time.value),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   )
//                 ],
//               ),
//             ),
//             ListView.builder(
//               itemCount: controller.items.length,
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemBuilder: (context, index) {
//                 bool isSelected =
//                     Get.currentRoute == controller.items[index].route;
//                 return ListTile(
//                   selected: isSelected,
//                   selectedTileColor: Colors.black12,
//                   leading: SizedBox(
//                     height: 20,
//                     width: 20,
//                     child: Image.asset(
//                       controller.items[index].icon,
//                       color: Colors.white,
//                     ),
//                   ),
//                   title: Text(
//                     controller.items[index].title,
//                     style: FontConstant().drawerStyle,
//                   ),
//                   onTap: () {
//                     if (controller.items[index].route == RoutesName.login) {
//                       AppData().clearData();
//                       DBFunctions().deleteDatabaseFile();
//                       Get.offNamedUntil(
//                         RoutesName.login,
//                         (route) => false,
//                       );
//                     } else if (Get.currentRoute ==
//                         controller.items[index].route) {
//                       Scaffold.of(context).closeDrawer();
//                     } else {
//                       Get.offNamed(controller.items[index].route);
//                     }
//                   },
//                 );
//               },
//             ),
//             const Divider(
//               color: Colors.white60,
//             ),
//             Container(
//                 padding: const EdgeInsets.all(8),
//                 width: double.infinity,
//                 child: Text(
//                   'Database',
//                   style: FontConstant().drawerStyle,
//                   textAlign: TextAlign.start,
//                 )),
//             ListView(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               children: [
//                 ListTile(
//                   leading: SizedBox(
//                     height: 20,
//                     width: 20,
//                     child: Image.asset(
//                       AssetConstant.import,
//                       color: Colors.white,
//                     ),
//                   ),
//                   title: Text(
//                     'Import',
//                     style: FontConstant().drawerStyle,
//                   ),
//                   onTap: () async {
//                     // await DBFunctions().importDB();
//                     await DBFunctions().getData();
//                   },
//                 ),
//                 ListTile(
//                   leading: SizedBox(
//                     height: 15,
//                     width: 15,
//                     child: Image.asset(
//                       AssetConstant.export,
//                       color: Colors.white,
//                     ),
//                   ),
//                   title: Text('Export', style: FontConstant().drawerStyle),
//                   onTap: () async {
//                     await DBFunctions().exportDB();
//                   },
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CustomMenu extends GetView<CustomMenuController> {
//   const CustomMenu({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       backgroundColor: AppStyle.radioColor,
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               width: double.infinity,
//               color: AppStyle.radioColor,
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 spacing: 12,
//                 children: [
//                   SizedBox(
//                     height: SizeConstant.percentToHeight(5),
//                   ),
//                   Container(
//                     alignment: Alignment.center,
//                     margin: EdgeInsets.only(top: 16),
//                     child: TextWidget(
//                       'OZONE ERP',
//                       textAlign: TextAlign.center,
//                       style: FontConstant.interMediumBold,
//                       color: Colors.white70,
//                     ),
//                   ),
//                   CustomPaint(
//                     size: Size(200, 3),
//                     painter: NeedleDividerPainter(),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     spacing: 12,
//                     children: [
//                       ClipOval(
//                         child: Container(
//                             alignment: Alignment.center,
//                             width: 50,
//                             height: 50,
//                             color: Colors.white,
//                             child: CachedNetworkImage(
//                               imageUrl: AppData().getCompanyLogo(),
//                               fit: BoxFit.cover,
//                               placeholder: (context, url) =>
//                                   const LoadingWidget(
//                                 width: double.infinity,
//                                 height: double.infinity,
//                               ),
//                               errorWidget: (context, url, error) =>
//                                   Image.asset(AssetConstant.logo),
//                             )),
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           TextWidget(
//                             AppData().getCompanyName().toUpperCase(),
//                             color: Colors.white,
//                             bold: true,
//                             style: FontConstant().drawerHeaderStyle,
//                           ),
//                           TextWidget(
//                             AppData().getUserName(),
//                             color: Colors.white,
//                           )
//                         ],
//                       )
//                     ],
//                   ),
//                   CustomPaint(
//                     size: Size(200, 3),
//                     painter: NeedleDividerPainter(),
//                   ),
//                   // Align(
//                   //   alignment: Alignment.center,
//                   //   child: Obx(
//                   //     () => TextWidget(
//                   //       controller.time.value,
//                   //       color: Colors.white,
//                   //     ),
//                   //   ),
//                   // ),
//                   const SizedBox(
//                     height: 20,
//                   )
//                 ],
//               ),
//             ),
//             ListView.builder(
//               itemCount: controller.items.length,
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemBuilder: (context, index) {
//                 bool isSelected =
//                     Get.currentRoute == controller.items[index].route;
//                 return MenuListItem(
//                     item: controller.items[index], selected: isSelected);
//                 // return ListTile(
//                 //   selected: isSelected,
//                 //   selectedTileColor: Colors.black12,
//                 //   leading: SizedBox(
//                 //     height: 20,
//                 //     width: 20,
//                 //     child: Image.asset(
//                 //       controller.items[index].icon,
//                 //       color: Colors.white,
//                 //     ),
//                 //   ),
//                 //   title: Text(
//                 //     controller.items[index].title,
//                 //     style: FontConstant().drawerStyle,
//                 //   ),
//                 //   onTap: () {
//                 //     if (controller.items[index].route == RoutesName.login) {
//                 //       AppData().clearData();
//                 //       DBFunctions().deleteDatabaseFile();
//                 //       Get.offNamedUntil(
//                 //         RoutesName.login,
//                 //         (route) => false,
//                 //       );
//                 //     } else if (Get.currentRoute ==
//                 //         controller.items[index].route) {
//                 //       Scaffold.of(context).closeDrawer();
//                 //     } else {
//                 //       Get.offNamed(controller.items[index].route);
//                 //     }
//                 //   },
//                 // );
//               },
//             ),
//             Container(
//                 padding: const EdgeInsets.all(8),
//                 margin: EdgeInsets.symmetric(
//                     vertical: SizeConstant.percentToHeight(5)),
//                 alignment: Alignment.center,
//                 width: double.infinity,
//                 child: Text(
//                   'Database',
//                   style: FontConstant().drawerStyle,
//                   textAlign: TextAlign.start,
//                 )),
//             ListTile(
//               leading: SizedBox(
//                 height: 20,
//                 width: 20,
//                 child: Image.asset(
//                   AssetConstant.import,
//                   color: Colors.white,
//                 ),
//               ),
//               title: Text(
//                 'Import',
//                 style: FontConstant().drawerStyle,
//               ),
//               onTap: () async {
//                 await DBFunctions().importDB();
//               },
//             ),
//             ListTile(
//               leading: SizedBox(
//                 height: 15,
//                 width: 15,
//                 child: Image.asset(
//                   AssetConstant.export,
//                   color: Colors.white,
//                 ),
//               ),
//               title: Text('Export', style: FontConstant().drawerStyle),
//               onTap: () async {
//                 await DBFunctions().exportDB();
//               },
//             ),
//             SizedBox(
//               height: SizeConstant.percentToHeight(10),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 for (int i = 0; i < 3; i++)
//                   Container(
//                       width: 10,
//                       height: 10,
//                       margin: const EdgeInsets.symmetric(horizontal: 8),
//                       decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(color: Colors.white)))
//               ],
//             ),
//             SizedBox(
//               height: SizeConstant.percentToHeight(10),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class CustomMenu extends GetView<CustomMenuController> {
  const CustomMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 12,
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 16),
                    child: TextWidget(
                      '',
                      textAlign: TextAlign.center,
                      style: FontConstant.interMediumBold,
                      color: Colors.black54,
                    ),
                  ),
                  CustomPaint(
                    size: Size(200, 3),
                    painter: NeedleDividerPainter(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 12,
                    children: [
                      ClipOval(
                        child: Container(
                            alignment: Alignment.center,
                            width: 50,
                            height: 50,
                            color: Colors.white,
                            child: CachedNetworkImage(
                              imageUrl: AppData().getCompanyLogo(),
                              placeholder: (context, url) =>
                                  const LoadingWidget(
                                width: double.infinity,
                                height: double.infinity,
                              ),
                              errorWidget: (context, url, error) =>
                                  Image.asset(AssetConstant.logo),
                            )),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextWidget(
                            AppData().getCompanyName().toUpperCase(),
                            color: Colors.black,
                            bold: true,
                            style: FontConstant().drawerHeaderStyle,
                          ),
                          TextWidget(
                            AppData().getUserName(),
                            color: Colors.black54,
                          )
                        ],
                      )
                    ],
                  ),
                  CustomPaint(
                    size: Size(200, 3),
                    painter: NeedleDividerPainter(),
                  ),
                  // Align(
                  //   alignment: Alignment.center,
                  //   child: Obx(
                  //     () => TextWidget(
                  //       controller.time.value,
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 20,
                  // )
                ],
              ),
            ),
            ListView.builder(
              itemCount: controller.items.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                bool isSelected =
                    Get.currentRoute == controller.items[index].route;
                return MenuListItem(
                    item: controller.items[index], selected: isSelected);
                // return ListTile(
                //   selected: isSelected,
                //   selectedTileColor: Colors.black12,
                //   leading: SizedBox(
                //     height: 20,
                //     width: 20,
                //     child: Image.asset(
                //       controller.items[index].icon,
                //       color: Colors.white,
                //     ),
                //   ),
                //   title: Text(
                //     controller.items[index].title,
                //     style: FontConstant().drawerStyle,
                //   ),
                //   onTap: () {
                //     if (controller.items[index].route == RoutesName.login) {
                //       AppData().clearData();
                //       DBFunctions().deleteDatabaseFile();
                //       Get.offNamedUntil(
                //         RoutesName.login,
                //         (route) => false,
                //       );
                //     } else if (Get.currentRoute ==
                //         controller.items[index].route) {
                //       Scaffold.of(context).closeDrawer();
                //     } else {
                //       Get.offNamed(controller.items[index].route);
                //     }
                //   },
                // );
              },
            ),
            const Divider(
              color: Colors.black87,
              thickness: 1,
              indent: 16,
              endIndent: 16,
            ),
            Container(
                padding: const EdgeInsets.all(8),
                width: double.infinity,
                child: Text(
                  'Database',
                  style: FontConstant()
                      .drawerStyle
                      .copyWith(color: Colors.black45),
                  textAlign: TextAlign.start,
                )),
            Column(
              children: [
                ListTile(
                  leading: SizedBox(
                    height: 20,
                    width: 20,
                    child: Image.asset(
                      AssetConstant.import,
                      color: Colors.black45,
                    ),
                  ),
                  title: Text(
                    'Import',
                    style: FontConstant()
                        .drawerStyle
                        .copyWith(color: Colors.black45),
                  ),
                  onTap: () async {
                    await DBFunctions().importDB();
                    // await DBFunctions().getData();
                  },
                ),
                ListTile(
                  leading: SizedBox(
                    height: 15,
                    width: 15,
                    child: Image.asset(
                      AssetConstant.export,
                      color: Colors.black45,
                    ),
                  ),
                  title: Text('Export',
                      style: FontConstant()
                          .drawerStyle
                          .copyWith(color: Colors.black45)),
                  onTap: () async {
                    await DBFunctions().exportDB();
                  },
                ),
                // ListTile(
                //   leading: SizedBox(
                //     height: 15,
                //     width: 15,
                //     child: Image.asset(
                //       AssetConstant.export,
                //       color: Colors.black45,
                //     ),
                //   ),
                //   title: Text('Copy',
                //       style: FontConstant()
                //           .drawerStyle
                //           .copyWith(color: Colors.black45)),
                //   onTap: () async {
                //     final db = await DBFunctions().copyAndOpenDatabase();
                //     final items = await DBFunctions().getDatabaseContents(db);
                //   },
                // ),
                SizedBox(
                  height: 50,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MenuListItem extends StatelessWidget {
  final MenuItem item;
  final bool selected;
  final VoidCallback? onTap;

  const MenuListItem(
      {super.key, required this.item, required this.selected, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (item.route == RoutesName.login) {
          AppData().storeIsLoggedIn(false);
          Get.offNamedUntil(
            RoutesName.login,
            (route) => false,
          );
        } else if (Get.currentRoute == item.route) {
          Scaffold.of(context).closeDrawer();
        } else {
          Get.offNamed(item.route);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
            color: selected ? AppStyle.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12)),
        width: double.infinity,
        height: SizeConstant.percentToHeight(7),
        child: Row(
          spacing: SizeConstant.percentToWidth(5),
          children: [
            SizedBox(
              height: SizeConstant.percentToWidth(5),
              width: SizeConstant.percentToWidth(5),
              child: Image.asset(
                item.icon,
                color: selected ? Colors.white : Colors.black45,
              ),
            ),
            Text(
              item.title,
              style: FontConstant().drawerStyle.copyWith(
                    color: selected ? Colors.white : Colors.black45,
                    fontSize: SizeConstant.font12,
                  ),
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}
