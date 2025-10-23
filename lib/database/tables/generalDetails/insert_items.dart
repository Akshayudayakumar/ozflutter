import 'package:sqflite/sqflite.dart';

import '../../../models/general_details.dart';
import '../../db_functions.dart';

class InsertItems {
  Future<void> insertItems(Items items) async {
    final db = await DBFunctions().database;
    await db.insert(DBFunctions.tableItems, items.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Items>> getItems() async {
    final db = await DBFunctions().database;
    final fetchedItems =
        await db.rawQuery('SELECT * FROM ${DBFunctions.tableItems}');
    return fetchedItems.map((e) => Items.fromJson(e)).toList();
  }

  Future<List<Items>> getLimitedItems(int limit, int offset) async {
    final db = await DBFunctions().database;
    final fetchedItems =
        await db.query(DBFunctions.tableItems, limit: limit, offset: offset);
    return fetchedItems.map((e) => Items.fromJson(e)).toList();
  }

  Future<Items> getItemById(String id) async {
    final db = await DBFunctions().database;
    final fetchedItem = await db
        .query(DBFunctions.tableItems, where: 'id = ?', whereArgs: [id]);
    return Items.fromJson(fetchedItem.first);
  }

  Future<void> updateItem(Items item) async {
    final db = await DBFunctions().database;
    await db.update(DBFunctions.tableItems, item.toJson(),
        where: 'id = ?', whereArgs: [item.id!]);
  }

  Future<void> updateItemStock(
      {required String id, required String quantity}) async {
    if (id.isEmpty || quantity.isEmpty) return;
    final db = await DBFunctions().database;
    await db.update(DBFunctions.tableItems, {'item_qty': quantity},
        where: 'id = ?', whereArgs: [id]);
  }
}
