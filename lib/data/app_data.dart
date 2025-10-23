import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ozone_erp/models/settings_model.dart';
import 'package:ozone_erp/models/user_model.dart';

class AppData {
  static final AppData appData = AppData._();

  late GetStorage _appData;

  factory AppData() => appData;

  AppData._() {
    _appData = GetStorage();
  }

static const String freeQuantity = 'freeQuantity';
  static const String userID = "userID";
  static const String userName = "userName";
  static const String userEmail = "userEmail";
  static const String userPhone = "userPhone";
  static const String companyID = "companyID";
  static const String companyName = 'CompanyName';
  static const String companyEmail = 'CompanyEmail';
  static const String upiID = 'upiID';
  static const String address = "address";
  static const String password = "password";
  static const String pdfSize = "pdfSize";
  static const String companyLogo = 'companyLogo';
  static const String image = 'image';
  static const String lastOpened = 'lastOpened';
  static const String disabledMenuItems = 'disabledMenuItems';
  static const String userKey = 'user';
  static const String invoiceKey = 'invoice';
  static const String syncDates = 'syncDates';
  static const String settings = 'settings';
  static const String initialRoute = 'initialRoute';
  static const String firstTimeLaunching = 'firstTimeLaunching';
  static const String deviceID = 'deviceID';
  static const String taxInclude = 'taxInclude';
  static const String isLoggedIn = 'isLoggedIn';
  static const String cartItems = 'cartItems';
  static const String cartQuantities = 'cartQuantities';
  static const String cartCustomer = 'cartCustomer';


  Future<String?> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; 
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor;
    }
    return null; 
  }

Future<void>storeFreeQuantity(bool isEnabled) async{
    await _appData.write(freeQuantity, isEnabled);
}

  storeUserID(String value) {
    _appData.write(userID, value);
  }

  storeUserName(String value) {
    _appData.write(userName, value);
  }

  storeUserEmail(String value) {
    _appData.write(userEmail, value);
  }

  storeUserPhone(String value) {
    _appData.write(userPhone, value);
  }

  storeAddress(String value) {
    _appData.write(address, value);
  }

  storeCompanyName(String value) {
    _appData.write(companyName, value);
  }

  storeCompanyEmail(String value) {
    _appData.write(companyEmail, value);
  }

  storeUpiID(String value) {
    _appData.write(upiID, value);
  }

  storePassword(String value) {
    _appData.write(password, value);
  }

  storePdfSize(String value) {
    _appData.write(pdfSize, value);
  }

  storeCompanyLogo(String value) {
    _appData.write(companyLogo, value);
  }

  storeImage(String value) {
    _appData.write(image, value);
  }

  storeFirstTimeLaunching() {
    _appData.write(firstTimeLaunching, false);
  }

  storeLastOpened() {
    _appData.write(
        lastOpened, DateTime.now().millisecondsSinceEpoch.toString());
  }

  storeDisabledMenuItems(List<String> ids) {
    _appData.write(disabledMenuItems, ids);
  }

  storeUser(Map<String, dynamic> user) {
    _appData.write(userKey, user);
  }

  storeInvoice(String value) {
    _appData.write(invoiceKey, value);
  }

  storeSyncDates(String key, String value) {
    Map<String, String> map = getSyncDates();
    map[key] = value;
    _appData.write(syncDates, map);
  }

  storeSettings(SettingsModel setting) {
    _appData.write(settings, setting.toJson());
  }

  storeInitialRoute(String route) {
    _appData.write(initialRoute, route);
  }

  Future<String?> storeDeviceId() async {
    String? deviceId = await getDeviceId();
    await _appData.write(deviceID, deviceId);
    return deviceId;
  }

  storeTaxInclude(bool value) {
    _appData.write(taxInclude, value);
  }

  storeCompanyID(String value) {
    _appData.write(companyID, value);
  }

  storeIsLoggedIn(bool value) {
    _appData.write(isLoggedIn, value);
  }

  
  storeCartItems(List<Map<String, dynamic>> items) {
    _appData.write(cartItems, items);
  }

  storeCartQuantities(Map<String, int> quantities) {
    _appData.write(cartQuantities, quantities);
  }

  storeCartCustomer(Map<String, dynamic>? customer) {
    _appData.write(cartCustomer, customer);
  }

 

  String getUserID() {
    return _appData.read(userID) ?? '';
  }

  String getUserName() {
    return _appData.read(userName) ?? '';
  }

  String getUserEmail() {
    return _appData.read(userEmail) ?? '';
  }

  String getUserPhone() {
    return _appData.read(userPhone) ?? '';
  }

  String getCompanyName() {
    return _appData.read(companyName) ?? '';
  }

  String getCompanyEmail() {
    return _appData.read(companyEmail) ?? '';
  }

  String getUpiID() {
    return _appData.read(upiID) ?? '';
  }

  String getAddress() {
    return _appData.read(address) ?? '';
  }

  String getPassword() {
    return _appData.read(password) ?? '';
  }

  String getPdfSize() {
    return _appData.read(pdfSize) ?? 'A4';
  }

  String getCompanyLogo() {
    return _appData.read(companyLogo) ?? '';
  }

  String getImage() {
    return _appData.read(image) ?? '';
  }

  String getLastOpened() {
    return _appData.read(lastOpened) ?? '';
  }
  bool getFreeQuantity(){
    return _appData.read(freeQuantity) ?? false;
  }

  /// Retrieves a list of menu item IDs that are disabled for the current user.
  List<String> getDisabledMenuItems() {
    // 1. Read the value associated with the `disabledMenuItems` key from storage.
    //    Since GetStorage can store various types, the result is typed as `List<dynamic>?`.
    //    It will be `null` if the key doesn't exist.
    List<dynamic>? list = _appData.read(disabledMenuItems);

    // 2. Check if the retrieved list is not null and not empty.
    return list != null && list.isNotEmpty
        // 3. If it's valid, iterate over the dynamic list, convert each element to a String,
        //    and collect them into a new `List<String>`.
        ? list.map((e) => e.toString()).toList()
        // 4. If the list is null or empty, return an empty `List<String>` to avoid errors.
        : [];
  }

  /// Retrieves the stored user data and deserializes it into a `UserModel` object.
  UserModel getUser() {
    // 1. Check if a value exists for the `userKey`. The value is expected to be a Map.
    return _appData.read(userKey) != null
        // 2. If data exists, cast it to `Map<String, dynamic>` and pass it to the
        //    `UserModel.fromJson` factory constructor to create a `UserModel` instance.
        ? UserModel.fromJson(_appData.read(userKey) as Map<String, dynamic>)
        // 3. If no data is found for `userKey`, return a new, empty `UserModel` object.
        : UserModel();
  }

  String getInvoice() {
    return _appData.read(invoiceKey) ?? '';
  }

  Map<String, String> getSyncDates() {
    Map<String, dynamic> data = _appData.read(syncDates) ?? {};
    Map<String, String> convertedData =
        data.map((key, value) => MapEntry(key, value.toString()));
    return convertedData;
  }

  SettingsModel getSettings() {
    return _appData.read(settings) != null
        ? SettingsModel.fromJson(
            _appData.read(settings) as Map<String, dynamic>)
        : SettingsModel();
  }

  String getInitialRoute() {
    return _appData.read(initialRoute) ?? '-1';
  }

  bool getFirstTimeLaunching() {
    return _appData.read(firstTimeLaunching) ?? true;
  }

  bool getIsLoggedIn() {
    return _appData.read(isLoggedIn) ?? false;
  }

  String getDeviceID() {
    return _appData.read(deviceID) ?? '';
  }

  String getCompanyID() {
    return _appData.read(companyID) ?? '';
  }

  bool getTaxInclude() {
    return _appData.read(taxInclude) ?? false;
  }

  List<Map<String, dynamic>> getCartItems() {
    List<dynamic>? items = _appData.read(cartItems);
    return items != null
        ? items.map((e) => Map<String, dynamic>.from(e)).toList()
        : [];
  }

  Map<String, int> getCartQuantities() {
    Map<String, dynamic>? quantities = _appData.read(cartQuantities);
    return quantities != null
        ? quantities.map((key, value) => MapEntry(key, value as int))
        : {};
  }

  Map<String, dynamic>? getCartCustomer() {
    return _appData.read(cartCustomer);
  }

  Map getFullMap() {
    final keys = _appData.getKeys().toList();
    Map map = {};
    for (var key in keys) {
      map[key] = _appData.read(key);
    }
    return map;
  }

 

  clearKey(String key) {
    _appData.remove(key);
  }

  clearData() {
    _appData.erase();
  }

  void clearCartData() {
    _appData.remove(cartItems);
    _appData.remove(cartQuantities);
    _appData.remove(cartCustomer);
  }
}
