import 'package:ozone_erp/database/db_functions.dart';
import 'package:ozone_erp/models/general_details.dart';

class InsertItemStock {
  // Future<void> insertItemStock(List<Items> items, [bool? clearStock]) async {
  //   final db = await DBFunctions().database;
  //   if (!await DBFunctions()
  //       .checkIfTableExists(db, DBFunctions.tableItemsStock)) {
  //     DBFunctions().createItemsStockTable(db);
  //   }
  //   if (clearStock ?? false) {
  //     await db.delete(DBFunctions.tableItemsStock);
  //   }
  //   for (var item in items) {
  //     await db.insert(DBFunctions.tableItemsStock, item.toJson(),
  //         conflictAlgorithm: ConflictAlgorithm.replace);
  //   }
  // }

  // Future<List<Items>> getItemStock() async {
  //   final db = await DBFunctions().database;
  //   if (!await DBFunctions()
  //       .checkIfTableExists(db, DBFunctions.tableItemsStock)) {
  //     DBFunctions().createItemsStockTable(db);
  //   }
  //   final fetchedItems = await db.query(DBFunctions.tableItemsStock);
  //   return fetchedItems.map((e) => Items.fromJson(e)).toList();
  // }

  // Future<Items?> getItemStockById(String id) async {
  //   final db = await DBFunctions().database;
  //   if (!await DBFunctions()
  //       .checkIfTableExists(db, DBFunctions.tableItemsStock)) {
  //     DBFunctions().createItemsStockTable(db);
  //   }
  //   final fetchedItems = await db
  //       .query(DBFunctions.tableItemsStock, where: 'id = ?', whereArgs: [id]);
  //   if (fetchedItems.isEmpty) return null;
  //   return Items.fromJson(fetchedItems.first);
  // }

  // Future<void> updateStockQuantity(Map<String, int> quantities) async {
  //   final db = await DBFunctions().database;
  //   final fetchedItems = await db.query(DBFunctions.tableItemsStock);
  //   List<Items> items = fetchedItems.map((e) => Items.fromJson(e)).toList();
  //   for (var item in items) {
  //     item.itemQty = quantities[item.id!].toString();
  //   }
  //   insertItemStock(items, true);
  // }

  Future<void> updateStockItemQuantity(
      {required String itemId,
      required int quantity,
      bool increment = true}) async {
    final db = await DBFunctions().database;
    final fetchedItems = await db.query(DBFunctions.tableItems);
    final items = fetchedItems.map((e) => Items.fromJson(e)).toList();
    Items itemToUpdate = items.firstWhere((element) => element.id == itemId);
    itemToUpdate.itemQty = increment
        ? (double.parse(itemToUpdate.itemQty!).round() + quantity).toString()
        : (double.parse(itemToUpdate.itemQty!).round() - quantity).toString();
    await db.update(DBFunctions.tableItems, itemToUpdate.toJson(),
        where: 'id = ?', whereArgs: [itemId]);
  }

  Future<void> setStockItemQuantity(
      {required String itemId, required int quantity}) async {
    final db = await DBFunctions().database;
    final fetchedItems = await db
        .query(DBFunctions.tableItems, where: 'id = ?', whereArgs: [itemId]);
    if (fetchedItems.isEmpty) {
      return;
    }
    Items itemToUpdate = Items.fromJson(fetchedItems.first);
    itemToUpdate.itemQty = quantity.toString();
    await db.update(DBFunctions.tableItems, itemToUpdate.toJson(),
        where: 'id = ?', whereArgs: [itemId]);
  }

  // Future<void> updateStockItem(Items item) async {
  //   final db = await DBFunctions().database;
  //   await db.update(DBFunctions.tableItems, item.toJson(),
  //       where: 'id = ?', whereArgs: [item.id!]);
  // }

  // Future<void> revertItemStock(List<Items> items) async {
  //   final db = await DBFunctions().database;
  //   final totalItems = await db.query(DBFunctions.tableItems);
  //   final allItems = totalItems
  //       .map(
  //         (e) => Items.fromJson(e),
  //       )
  //       .toList();
  //   for (var dbItem in allItems) {
  //     for (var item in items) {
  //       if (dbItem.id == item.id) {
  //         dbItem.itemQty = ((double.parse(dbItem.itemQty ?? '0') +
  //                     double.parse(item.itemQty ?? '0'))
  //                 .round())
  //             .toString();
  //       }
  //     }
  //     await db.update(DBFunctions.tableItems, dbItem.toJson(),
  //         where: 'id = ?', whereArgs: [dbItem.id!]);
  //   }
  //   await db.delete(DBFunctions.tableItemsStock);
  // }

  // Future<void> clearItemStock() async {
  //   final db = await DBFunctions().database;
  //   await db.delete(DBFunctions.tableItemsStock);
  // }
}
