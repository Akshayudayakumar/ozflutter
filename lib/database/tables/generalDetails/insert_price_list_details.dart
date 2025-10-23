import 'package:sqflite/sqflite.dart';

import '../../../models/general_details.dart';
import '../../db_functions.dart';

class InsertPriceListDetails {
  Future<void> insertPriceListDetails(PriceListDetails priceListDetails) async {
    final db = await DBFunctions().database;
    await db.insert(
        DBFunctions.tablePriceListDetails, priceListDetails.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<PriceListDetails>> getPriceListDetails() async {
    final db = await DBFunctions().database;
    final fetchedDetails = await db.query(DBFunctions.tablePriceListDetails);
    return fetchedDetails.map((e) => PriceListDetails.fromJson(e)).toList();
  }

  Future<PriceListDetails> getPriceListDetailsById(String id) async {
    final db = await DBFunctions().database;
    final fetchedDetails = await db.query(DBFunctions.tablePriceListDetails,
        where: "price_list_id = ?", whereArgs: [id]);
    if (fetchedDetails.isEmpty) return PriceListDetails();
    return PriceListDetails.fromJson(fetchedDetails.first);
  }

  Future<PriceListDetails> getPriceListDetailsByItemId(String id) async {
    final db = await DBFunctions().database;
    final fetchedDetails = await db.query(DBFunctions.tablePriceListDetails,
        where: 'item_id = ?', whereArgs: [id]);
    if (fetchedDetails.isEmpty) return PriceListDetails();
    return PriceListDetails.fromJson(fetchedDetails.first);
  }
}
