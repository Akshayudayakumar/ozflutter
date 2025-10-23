import 'package:ozone_erp/database/db_functions.dart';
import 'package:ozone_erp/models/return_log.dart';
import 'package:sqflite/sqflite.dart';

class ReturnLogTxn {
  Future<void> insertReturnLog(ReturnLog log) async {
    final db = await DBFunctions().database;
    await DBFunctions().createReturnLogTable(db);
    await db.insert(DBFunctions.returnLog, log.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<ReturnLog?> getReturnLog({
    required String? salesId,
    required String? itemId,
    required String? invoice,
  }) async {
    final db = await DBFunctions().database;
    await DBFunctions().createReturnLogTable(db);
    final fetchedLogs = await db.query(DBFunctions.returnLog,
        where: 'sales_id = ? AND item_id = ? AND invoice = ?',
        whereArgs: [salesId, itemId, invoice]);
    if (fetchedLogs.isEmpty) return null;
    return ReturnLog.fromJson(fetchedLogs.first);
  }

  Future<List<ReturnLog>> getReturnLogWithSalesId(String salesId) async {
    final db = await DBFunctions().database;
    await DBFunctions().createReturnLogTable(db);
    final fetchedLogs = await db.query(
      DBFunctions.returnLog,
      where: 'sales_id = ?',
      whereArgs: [salesId],
    );
    return fetchedLogs.map((log) => ReturnLog.fromJson(log)).toList();
  }

  Future<void> updateReturnQuantity({
    required String? salesId,
    required String? itemId,
    required String? invoice,
    required int quantity,
  }) async {
    final db = await DBFunctions().database;
    await DBFunctions().createReturnLogTable(db);
    await db.update(
      DBFunctions.returnLog,
      {'return_quantity': quantity.toString()},
      where: 'sales_id = ? AND item_id = ? AND invoice = ?',
      whereArgs: [salesId, itemId, invoice],
    );
  }
}
