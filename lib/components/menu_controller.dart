import 'dart:async';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ozone_erp/data/app_data.dart';
import 'package:ozone_erp/models/menu_item.dart';
import 'package:ozone_erp/models/user_model.dart';

import '../database/tables/export_insert.dart';

class CustomMenuController extends GetxController {
  String path = AppData().getImage();
  // RxString time = 'Time'.obs;

  /// This is a lifecycle method from the GetX package.
  /// It is called automatically when the controller is initialized and
  /// allocated in memory for the first time.
  @override
  void onInit() {
    // Fetches user data from the database and updates the UI.
    getUser();
    // Checks if this is the first time the app is launched. If so, it sets up
    // a default list of disabled menu items.
    firstTimeLaunching();
    // Retrieves the stored image path for the logo from local storage.
    AppData().getImage();
    // Fetches the list of menu items from the database and updates the UI.
    getItems();
    // updateTime();
    // Calls the onInit method of the parent class (GetxController) to complete initialization.
    super.onInit();
  }

  UserModel? user;

  List<MenuItem> items = [];

  getItems() async {
    items = await InsertMenuItem().getMenuItem();
    // final itemToUpdate = items.firstWhere((element) => element.id == '0');
    // itemToUpdate.title = 'Stock List';
    // await InsertMenuItem().updateMenuItem(itemToUpdate);
    items = items
        .where(
            (element) => !AppData().getDisabledMenuItems().contains(element.id))
        .toList();
    update();
  }

  firstTimeLaunching() {
    if (AppData().getFirstTimeLaunching()) {
      List<String> disabledCategories = [
        '0',
        '1',
        '2',
        '3',
        '4',
        '6',
        '7',
        '8',
        '9',
        '10',
        '11',
        '12',
        '13'
      ];
      AppData().storeDisabledMenuItems(disabledCategories);
      AppData().storeFirstTimeLaunching();
    }
  }

  // updateTime() {
  //   Timer.periodic(const Duration(seconds: 1), (value) {
  //     DateTime now = DateTime.now();
  //     String month = now.month.toString().padLeft(2, '0');
  //     String day = now.day.toString().padLeft(2, '0');
  //     String hour =
  //         (now.hour % 12 == 0 ? 12 : now.hour % 12).toString().padLeft(2, '0');
  //     String minute = now.minute.toString().padLeft(2, '0');
  //     String second = now.second.toString().padLeft(2, '0');
  //     String formattedDate =
  //         '${now.year}-$month-$day $hour:$minute:$second ${now.hour >= 12 ? 'pm' : 'am'}';
  //     time.value = formattedDate;
  //   });
  // }

  Future<void> selectLogo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Get.back();
      AppData().storeImage(pickedFile.path);
      path = pickedFile.path;
    }
    update();
  }

  getUser() async {
    user = await InsertUserModel().getUserModel();
    update();
  }
}
