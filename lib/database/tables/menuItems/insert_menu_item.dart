import 'package:ozone_erp/database/db_functions.dart';
import 'package:ozone_erp/models/menu_item.dart';
import 'package:sqflite/sqflite.dart';

import '../../../constants/constant.dart';
import '../../../routes/routes_class.dart';

class InsertMenuItem {
  List<MenuItem> items = [
    MenuItem(
        id: '0',
        title: 'Stock List',
        icon: AssetConstant.transfer,
        route: RoutesName.stockTransfer),
    MenuItem(
        id: '1',
        title: 'Sales Bill',
        icon: AssetConstant.sales,
        route: RoutesName.newSale),
    MenuItem(
        id: '2',
        title: 'Sales Order',
        icon: AssetConstant.purchase,
        route: RoutesName.newOrder),
    MenuItem(
        id: '3',
        title: 'Sales Return',
        icon: AssetConstant.salesReturn,
        route: RoutesName.salesReturn),
    MenuItem(
        id: '4',
        title: 'Register',
        icon: AssetConstant.stack,
        route: RoutesName.register),
    MenuItem(
        id: '5',
        title: 'Dashboard',
        icon: AssetConstant.dashboard,
        route: RoutesName.dashboard),
    MenuItem(
        id: '6',
        title: 'Customers',
        icon: AssetConstant.customers,
        route: RoutesName.customers),
    MenuItem(
        id: '7',
        title: 'Items Wise Sales report',
        icon: AssetConstant.stock,
        route: RoutesName.itemWiseReport),
    MenuItem(
        id: '8',
        title: 'Stock',
        icon: AssetConstant.stock,
        route: RoutesName.stocks),
    MenuItem(
        id: '9',
        title: 'Payment Voucher',
        icon: AssetConstant.paymentVoucher,
        route: RoutesName.paymentVoucher),
    MenuItem(
        id: '10',
        title: 'Receipt Voucher',
        icon: AssetConstant.receipt,
        route: RoutesName.receiptVoucher),
    MenuItem(
        id: '11',
        title: 'Vouchers',
        icon: AssetConstant.voucher,
        route: RoutesName.vouchers),
    MenuItem(
        id: '13',
        title: 'Customer Account',
        icon: AssetConstant.profile,
        route: RoutesName.customerAccount),
    MenuItem(
        id: '14',
        title: 'Sync',
        icon: AssetConstant.sync,
        route: RoutesName.sync),
    MenuItem(
        id: '15',
        title: 'Settings',
        icon: AssetConstant.settings,
        route: RoutesName.settings),
    MenuItem(
        id: '16',
        title: 'Logout',
        icon: AssetConstant.logout,
        route: RoutesName.login),
  ];

  Future<void> insertMenuItem(MenuItem item) async {
    final db = await DBFunctions().database;
    if (!await DBFunctions()
        .checkIfTableExists(db, DBFunctions.tableMenuItems)) {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DBFunctions.tableMenuItems} (
        id TEXT PRIMARY KEY,
        title TEXT,
        icon TEXT,
        route TEXT
      )''');
      for (var item in items) {
        await db.insert(DBFunctions.tableMenuItems, item.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
    await db.insert(DBFunctions.tableMenuItems, item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<MenuItem>> getMenuItem() async {
    final db = await DBFunctions().database;
    if (!await DBFunctions()
        .checkIfTableExists(db, DBFunctions.tableMenuItems)) {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DBFunctions.tableMenuItems} (
        id TEXT PRIMARY KEY,
        title TEXT,
        icon TEXT,
        route TEXT
      )''');
      for (var item in items) {
        await db.insert(DBFunctions.tableMenuItems, item.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
    final fetchedData = await db.query(DBFunctions.tableMenuItems);
    return fetchedData.map((e) => MenuItem.fromJson(e)).toList();
  }

  Future<void> updateMenuItem(MenuItem item) async {
    final db = await DBFunctions().database;
    await db.update(DBFunctions.tableMenuItems, item.toJson(),
        where: 'id = ?', whereArgs: [item.id]);
  }
}
