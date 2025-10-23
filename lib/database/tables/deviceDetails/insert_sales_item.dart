import 'package:ozone_erp/models/device_details.dart';
import 'package:sqflite/sqflite.dart';

import '../../db_functions.dart';

class InsertSalesItem {
  Future<void> insertSalesItem(SalesItems salesItems) async {
    final db = await DBFunctions().database;
    await db.insert(DBFunctions.tableSalesItems, salesItems.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<SalesItems>> getSalesItems() async {
    final db = await DBFunctions().database;
    final fetchedItems =
        await db.rawQuery('SELECT * FROM ${DBFunctions.tableSalesItems}');
    return fetchedItems.map((e) => SalesItems.fromJson(e)).toList();
  }
}
