import 'package:get/get.dart';
import 'package:ozone_erp/database/tables/export_insert.dart';
import 'package:ozone_erp/models/menu_item.dart';
import 'package:ozone_erp/models/settings_model.dart';
import 'package:ozone_erp/utils/utils.dart';

import '../../../data/app_data.dart';
import '../../../routes/routes_class.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    navigate();
    super.onInit();
  }

  String storedRoute = AppData().getInitialRoute();

  List<MenuItem> menu = [];

  SettingsModel settings = AppData().getSettings();

  void navigate() async {
    try {
      // await sendAppOpenReport();
      List<String> disabledMenuItems = AppData().getDisabledMenuItems();
      menu = (await InsertMenuItem().getMenuItem())
          .where((element) => !disabledMenuItems.contains(element.id))
          .toList();
      bool isUserLoggedIn = AppData().getIsLoggedIn();
      // String lastOpened = AppData().getLastOpened();
      // DateTime? lastOpenedTime;
      // if (lastOpened.isNotEmpty) {
      //   lastOpenedTime =
      //       DateTime.fromMillisecondsSinceEpoch(int.parse(lastOpened));
      // }
      // DateTime now = DateTime.now();
      // bool firstTimeLaunching = lastOpened.isNotEmpty
      //     ? lastOpenedTime?.day != now.day ||
      //         lastOpenedTime?.month != now.month ||
      //         lastOpenedTime?.year != now.year
      //     : true;
      // AppData().storeLastOpened();
      String initialRoute = menu
          .where(
            (element) => !disabledMenuItems.contains(element.id),
          )
          .first
          .route;
      // String secondRoute = Get.find<CustomMenuController>()
      //     .items
      //     .where(
      //       (element) => !disabledMenuItems.contains(element.id),
      //     )
      //     .toList()[1]
      //     .route;
      // String firstRoute = isUserLoggedIn
      //     ? firstTimeLaunching
      //         ? !disabledMenuItems.contains('0')
      //             ? RoutesName.stockTransfer
      //             : initialRoute
      //         : initialRoute == RoutesName.stockTransfer
      //             ? secondRoute
      //             : initialRoute
      //     : RoutesName.login;
      String firstRoute = isUserLoggedIn ? initialRoute : RoutesName.login;
      final firstMenu = menu.firstWhere((element) => element.id == storedRoute,
          orElse: () => MenuItem(id: '-1', title: 'None', icon: '', route: ''));
      firstRoute = firstMenu.id != '-1' ? firstMenu.route : firstRoute;
      Get.offNamed(firstRoute);
    } catch (e) {
      Utils().showToast('$e');
    }
  }
}
