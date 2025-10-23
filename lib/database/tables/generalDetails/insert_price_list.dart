import 'package:ozone_erp/models/general_details.dart';
import 'package:sqflite/sqflite.dart';

import '../../db_functions.dart';

class InsertPriceList {
  Future<void> insertPriceList(PriceList priceList) async {
    final db = await DBFunctions().database;
    await db.insert(DBFunctions.tablePriceList, priceList.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<PriceList>> getPriceList() async {
    final db = await DBFunctions().database;
    final fetchedPriceList = await db.query(DBFunctions.tablePriceList);
    return fetchedPriceList.map((e) => PriceList.fromJson(e)).toList();
  }

  Future<PriceList> getPriceListById(String id) async {
    final db = await DBFunctions().database;
    final data = await db
        .query(DBFunctions.tablePriceList, where: "id = ?", whereArgs: [id]);
    if (data.isEmpty) {
      return PriceList();
    }
    return PriceList.fromJson(data.first);
  }
}
