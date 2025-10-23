import 'package:ozone_erp/database/db_functions.dart';
import 'package:sqflite/sqflite.dart';

class VoucherBodySync {
  Future<void> createVoucherBodySyncTable(Database db) async {
    await DBFunctions.createTable(db, DBFunctions.tableVoucherBodySync,
        {'id': 'TEXT PRIMARY KEY', 'status': 'INTEGER', 'update_date': 'TEXT'});
  }

  Future<void> insertVoucherBodySync(
      {required String id, required int status}) async {
    final db = await DBFunctions().database;
    String now = DateTime.now().millisecondsSinceEpoch.toString();
    if (!await DBFunctions()
        .checkIfTableExists(db, DBFunctions.tableVoucherBodySync)) {
      await createVoucherBodySyncTable(db);
    }
    await db.insert(DBFunctions.tableVoucherBodySync,
        {'id': id, 'status': status, 'update_date': now},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateVoucherBodySync(
      {required String id, required int status}) async {
    final db = await DBFunctions().database;
    String now = DateTime.now().millisecondsSinceEpoch.toString();
    if (!await DBFunctions()
        .checkIfTableExists(db, DBFunctions.tableVoucherBodySync)) {
      await createVoucherBodySyncTable(db);
    }
    await db.update(DBFunctions.tableVoucherBodySync,
        {'status': status, 'update_date': now},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getVoucherBodySync() async {
    final db = await DBFunctions().database;
    if (!await DBFunctions()
        .checkIfTableExists(db, DBFunctions.tableVoucherBodySync)) {
      await createVoucherBodySyncTable(db);
    }
    final fetchedData = await db.query(DBFunctions.tableVoucherBodySync);
    return fetchedData;
  }

  Future<List<Map<String, dynamic>>> getNotSyncedVoucherBodySync() async {
    final db = await DBFunctions().database;
    if (!await DBFunctions()
        .checkIfTableExists(db, DBFunctions.tableVoucherBodySync)) {
      await createVoucherBodySyncTable(db);
    }
    final fetchedData = await db.query(DBFunctions.tableVoucherBodySync,
        where: 'status = ?', whereArgs: [0]);
    return fetchedData;
  }
}
