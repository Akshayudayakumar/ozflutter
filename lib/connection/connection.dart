import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
/// The `Connection` class manages the application's network connectivity status.
/// It uses the `connectivity_plus` package to listen for changes in the network
/// state and updates the UI accordingly, primarily by managing dialogs using `get`.
class Connection{
  /// A static variable to hold the latest connectivity status.
  /// `late final` means it will be initialized exactly once at runtime.
  static late final ConnectivityResult connectivity;

  /// Configures a stream to listen for connectivity changes.
  /// This method should be called once when the application starts.
  static void configureConnectivityStream() {
    // `Connectivity().onConnectivityChanged` provides a stream of `List<ConnectivityResult>`.
    // We listen to this stream to get real-time updates on network status.
    Connectivity().onConnectivityChanged.listen(
      (event) {
        // The `event` is a list of results. We are interested in the first one.
        // It's a list to support multiple network connections in the future,
        // but currently, it usually contains one element.
        connectivity = event[0];
        // A switch statement to handle different types of connectivity results.
        switch (event[0]) {
          case ConnectivityResult.wifi:
            try {
              if (Get.context != null) {
                Get.until(
                    (Route<dynamic> route) => !(Get.isDialogOpen ?? false));
              }
            } catch (e) {
              // This block handles cases where we have an active internet connection (wifi, mobile, etc.).
              // `Get.until` is used to close any open dialogs. This is useful for automatically
              // dismissing a "No Internet" dialog when the connection is restored.
              // The predicate `(Route<dynamic> route) => !(Get.isDialogOpen ?? false)`
              // will pop routes until there are no more dialogs open.
              debugPrint("GetUntilMethodOnWifiConnectionError: $e");
            }
            debugPrint("ConnectivityResult: Internet Connection With Wifi.");
            break;
          case ConnectivityResult.bluetooth:
            try {
              if (Get.context != null) {
                Get.until(
                    (Route<dynamic> route) => !(Get.isDialogOpen?? false));
              }
            } catch (e) {
              debugPrint("GetUntilMethodOnBluetoothConnectionError: $e");
            }
            debugPrint(
                "ConnectivityResult: Internet Connection With Bluetooth.");
            break;
          case ConnectivityResult.ethernet:
            try {
              if (Get.context != null) {
                Get.until(
                    (Route<dynamic> route) => !(Get.isDialogOpen ?? false));
              }
            } catch (e) {
              debugPrint("GetUntilMethodOnEthernetConnectionError: $e");
            }
            debugPrint(
                "ConnectivityResult: Internet Connection With Ethernet.");
            break;
          case ConnectivityResult.mobile:
            try {
              if (Get.context != null) {
                Get.until(
                    (Route<dynamic> route) => !(Get.isDialogOpen ?? false));
              }
            } catch (e) {
              debugPrint("GetUntilMethodOnMobileConnectionError: $e");
            }
            debugPrint("ConnectivityResult: Internet Connection With Mobile.");
            break;
          case ConnectivityResult.none:
            debugPrint("ConnectivityResult: No Internet Connection.");
            // This case handles when there is no network connection.
            // Here, you would typically show a "No Internet" dialog or snackbar to the user.
            try {
              if (Get.context != null) {
                Get.until(
                        (Route<dynamic> route) => !(Get.isDialogOpen ?? false));
              }
            } catch (e) {
              debugPrint("ShowNoInternetConnectionDialogError: $e");
            }
            break;
          case ConnectivityResult.vpn:
            debugPrint("ConnectivityResult: Internet Connection With VPN.");
            break;
          case ConnectivityResult.other:
            break;
        }
      },
    );
  }
}
