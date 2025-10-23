import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/components/menu_controller.dart';
import 'package:ozone_erp/widgets/export_widgets.dart';

import '../constants/constant.dart';

/// A custom AppBar widget that provides a consistent look and feel across the app.
AppBar customAppBar({
  String? title,
  IconThemeData? iconTheme,
  Color? color,
  TextStyle? style,
  bool centerTitle = false,
  TabBar? tabBar,
  List<Widget>? actions,
  bool whiteIcon = false,
  VoidCallback? refresh,
  VoidCallback? sync,
  String? syncTitle,
  Brightness? statusIconBrightness,
}) {
  String? route;
  // Check if a CustomMenuController is registered with GetX.
  if (Get.isRegistered<CustomMenuController>()) {
    // Find the menu item corresponding to the current route.
    final items = Get.find<CustomMenuController>().items.where(
          (element) => element.route == Get.currentRoute,
        );
    // Set the route title if found, otherwise set it to an empty string.
    items.isNotEmpty ? route = items.first.title : route = '';
  }
  return AppBar(
    toolbarHeight: 55.h,
    iconTheme: iconTheme,
    systemOverlayStyle: SystemUiOverlayStyle(
      // Set the color of the status bar.
      statusBarColor: color ?? AppStyle.primaryColor,
      // Set the brightness of the status bar icons (e.g., time, battery).
      statusBarIconBrightness: statusIconBrightness ??
          (whiteIcon
              ? Brightness.light
              : color == null
                  ? Brightness.light
                  : Brightness.dark),
      // Set the color of the system navigation bar.
      systemNavigationBarColor: color ?? AppStyle.primaryColor,
    ),
    bottom: tabBar,
    backgroundColor: color ?? AppStyle.primaryColor,
    centerTitle: centerTitle,
    // Default text style for the title, can be overridden by the `title` widget's style.
    titleTextStyle: FontConstant.inter.copyWith(
        fontWeight: FontWeight.bold,
        color: AppStyle.whiteColor,
        fontSize: SizeConstant.font14),
    title: Text(
      // Use the provided title, or the route title, or an empty string.
      title ?? route ?? '',
      textAlign: TextAlign.center,
      // Apply the provided style or the default style.
      style: style ??
          FontConstant.inter.copyWith(
              fontWeight: FontWeight.bold,
              color: AppStyle.whiteColor,
              fontSize: SizeConstant.font14),
    ),
    actions: [
      // Include any custom actions passed to the function.
      ...?actions,
      // If refresh or sync callbacks are provided, show a PopupMenuButton.
      if (refresh != null || sync != null)
        PopupMenuButton(
            itemBuilder: (context) => [
                  // Show 'Refresh' option if the callback is provided.
                  if (refresh != null)
                    PopupMenuItem(
                      child: TextWidget('Refresh'),
                      onTap: refresh,
                    ),
                  // Show 'Sync' option if the callback is provided.
                  if (sync != null)
                    PopupMenuItem(
                        child: TextWidget(syncTitle ?? 'Sync'), onTap: sync),
                ])
    ],
  );
}
