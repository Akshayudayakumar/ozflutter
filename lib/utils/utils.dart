import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ozone_erp/constants/constant.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils{
  /// A utility class containing static helper methods for common tasks
  /// such as validation, UI notifications, date formatting, and more.
  ///
  /// ### `validateEmpty(String? v)`
  /// This is a static validator function designed for `TextFormField` widgets.
  ///
  /// - **Purpose**: To check if a text field is empty.
  /// - **Parameters**: It takes a nullable `String` `v`, which is the value from the text field.
  /// - **Logic**:
  ///   - `v!.isEmpty`: It uses the null-check operator (`!`) to assert that `v` is not null before checking if it's empty. This is safe within a `TextFormField`'s validator, which is only called with a non-null (though possibly empty) string.
  ///   - If the string is empty, it returns a translated error message 'field_cant_be_empty'. The `.tr` is from the `GetX` package for localization.
  ///   - If the string is not empty, it returns `null`, indicating that the validation has passed.
  /// - **Return**: A `String?` which is either an error message or `null`.
  static String? validateEmpty(String? v) {
    if (v!.isEmpty) {
      return 'field_cant_be_empty'.tr;
    } else {
      return null;
    }
  }

  static String? validateTEmpty<T>(T? v) {
    if (v == null) {
      return 'field_cant_be_empty'.tr;
    } else {
      return null;
    }
  }

  static String? validatePhone(String? v) {
    if (v!.isEmpty) {
      return 'field_cant_be_empty'.tr;
    } else if (v.length != 10) {
      return 'please_enter_a_valid_mobile_number'.tr;
    } else {
      return null;
    }
  }

  static void unfocus() {
    if (!Get.focusScope!.hasPrimaryFocus) {
      Get.focusScope?.unfocus();
    }
  }

  static hideKeyboard() {
    Get.focusScope?.unfocus();
  }

  /// Displays an auto-closing alert dialog with optional action buttons.
  ///
  /// This function shows an `AlertDialog` with a [title] and [content].
  /// By default, the dialog will **automatically close after 5 seconds**,
  /// unless the user manually closes it using the close button.
  ///
  /// ### Features:
  /// - Prevents dismissal by tapping outside (`barrierDismissible: false`).
  /// - **Auto-closes after 5 seconds** using a `Timer`.
  /// - Allows an optional **close button** (`showCloseButton`).
  /// - Supports **extra action buttons** (`extraActionButtons`).
  /// - Calls [onClose] when the dialog is dismissed.
  ///
  /// ### Example:
  /// ```dart
  /// closableAlert(
  ///   context: context,
  ///   title: "Session Expired",
  ///   content: "Your session has expired. Please log in again.",
  ///   onClose: () => print("Dialog closed"),
  ///   extraActionButtons: [
  ///     TextButton(
  ///       onPressed: () => print("Extra Action"),
  ///       child: Text("Retry"),
  ///     )
  ///   ],
  /// );
  /// ```
  ///
  /// - [context]: The `BuildContext` required to display the dialog.
  /// - [title]: The title of the alert dialog.
  /// - [content]: The content message of the alert dialog.
  /// - [onClose]: A callback function triggered when the dialog is closed.
  /// - [extraActionButtons]: A list of additional action buttons.
  /// - [showCloseButton]: Whether to show a close button (default: `true`).
  void closableAlert({
    required BuildContext context,
    required String title,
    required String content,
    VoidCallback? onClose,
    List<Widget>? extraActionButtons,
    bool showCloseButton = true,
  }) {
    // Duration for the timer (e.g., 5 seconds)
    const Duration duration = Duration(seconds: 5);
    Timer? timer;

    // Show the AlertDialog
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismiss by tapping outside
      builder: (BuildContext context) {
        // Start a timer to close the dialog after the specified duration
        timer = Timer(duration, () {
          Navigator.of(context)
              .pop(); // Close the dialog if the timer completes
        });

        return AlertDialog(
          title: Text(title),
          content: Text(content),
          backgroundColor: Colors.white,
          actions: [
            if (showCloseButton)
              TextButton(
                onPressed: () {
                  // Cancel the timer and close the dialog when the user presses the button
                  timer?.cancel();
                  Navigator.of(context).pop();
                  onClose?.call();
                },
                child: const Text(
                  'Close',
                  style: TextStyle(color: AppStyle.radioColor),
                ),
              ),
            ...extraActionButtons ?? [],
          ],
        );
      },
    ).then((_) {
      // Ensure the timer is canceled if the dialog is closed early
      timer?.cancel();
      onClose?.call();
    });
  }

  showToast(String msg,
      {Toast? length, backgroundColor, textColor, double? fontSize}) {
    cancelToast();
    return Fluttertoast.showToast(
        msg: msg,
        toastLength: length ?? Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: backgroundColor ?? AppStyle.blackColor,
        textColor: textColor ?? AppStyle.whiteColor,
        fontSize: fontSize ?? SizeConstant.font14);
  }

  cancelToast() {
    return Fluttertoast.cancel();
  }

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('dd-MM-yyyy');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  String convertDateTimeDisplayWithDay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('EEE');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  String convertDateTimeAPI(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  // String convertTimeDisplay(String date) {
  //   final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
  //   final DateFormat serverFormater = DateFormat('HH:mm:ss');
  //   final DateTime displayDate = displayFormater.parse(date);
  //   final String formatted = serverFormater.format(displayDate);
  //   return formatted;
  // }

  static const platform = MethodChannel('sms_channel');
  static Future<void> sendSMS(
      {required String phone, required String message}) async {
    if (Platform.isAndroid) {
      if (await Permission.sms.request().isDenied) return;
      try {
        await platform.invokeMethod('sendSMS', {
          'phone': phone,
          'message': message,
        });
      } catch (e) {
        Utils().showToast('Could not send SMS');
      }
    } else {
      try {
        Uri uri = Uri(scheme: 'sms', path: phone, query: 'body=$message');
        await launchUrl(uri);
      } catch (e) {
        print(e);
      }
    }
  }

  removeSqr(String value) {
    String a = value.replaceAll("[", "");
    return a.replaceAll("]", "");
  }

  num roundIfWhole(num value) {
    return value == value.round() ? value.round() : value;
  }

  String roundWithFixedDecimal(num value) {
    return value == value.round()
        ? value.round().toString()
        : value.toStringAsFixed(2);
  }

  static void showLoading([String? message]) {
    Get.dialog(
        Dialog(
          child: Padding(
            padding: EdgeInsets.all(SizeConstant.sp16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  color: AppStyle.primaryColor,
                ),
                SizedBox(height: SizeConstant.h8),
                Text(message ?? 'Loading'.tr),
              ],
            ),
          ),
        ),
        barrierDismissible: false);
  }
}

var mySystemThemeDark = SystemUiOverlayStyle.dark.copyWith(
  statusBarColor: Colors.transparent,
);

createdDateFormate(value) {
  String dateString = value.toString();
  DateTime dateTime = DateTime.parse(dateString);

  String formattedDate = DateFormat.yMMMMd().format(dateTime);
  return formattedDate;
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
