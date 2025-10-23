import 'package:sqflite/sqflite.dart';

import '../../db_functions.dart';

class SalesBodySync {
  Future<void> insertSalesBodySync(
      {required String id, required int status}) async {
    final db = await DBFunctions().database;
    if (!await DBFunctions()
        .checkIfTableExists(db, DBFunctions.tableSalesBodySync)) {
      await db.execute('''
      CREATE TABLE ${DBFunctions.tableSalesBodySync} (
        id TEXT PRIMARY KEY,
        status INTEGER,
        update_date TEXT
      )
      ''');
    }
    String now = DateTime.now().millisecondsSinceEpoch.toString();
    await db.insert(DBFunctions.tableSalesBodySync,
        {'id': id, 'status': status, 'update_date': now},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateSalesBodySync(
      {required String id, required int status}) async {
    final db = await DBFunctions().database;
    if (!await DBFunctions()
        .checkIfTableExists(db, DBFunctions.tableSalesBodySync)) {
      await db.execute('''
      CREATE TABLE ${DBFunctions.tableSalesBodySync} (
        id TEXT PRIMARY KEY,
        status INTEGER,
        update_date TEXT
      )
      ''');
    }
    String now = DateTime.now().millisecondsSinceEpoch.toString();
    await db.update(
        DBFunctions.tableSalesBodySync, {'status': status, 'update_date': now},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>?> getSalesBodySyncById(String id) async {
    final db = await DBFunctions().database;
    if (!await DBFunctions()
        .checkIfTableExists(db, DBFunctions.tableSalesBodySync)) {
      await db.execute('''
      CREATE TABLE ${DBFunctions.tableSalesBodySync} (
        id TEXT PRIMARY KEY,
        status INTEGER,
        update_date TEXT
      )
      ''');
    }
    final fetchedData = await db.query(DBFunctions.tableSalesBodySync,
        where: 'id = ?', whereArgs: [id]);
    return fetchedData.isEmpty ? null : fetchedData.first;
  }

  Future<List<Map<String, dynamic>>> getSalesBodySync() async {
    final db = await DBFunctions().database;
    if (!await DBFunctions()
        .checkIfTableExists(db, DBFunctions.tableSalesBodySync)) {
      await db.execute('''
      CREATE TABLE ${DBFunctions.tableSalesBodySync} (
        id TEXT PRIMARY KEY,
        status INTEGER,
        update_date TEXT
      )
      ''');
    }
    final fetchedData = await db.query(DBFunctions.tableSalesBodySync);
    return fetchedData;
  }

  Future<List<Map<String, dynamic>>> getNotSyncedSalesBodySync() async {
    final db = await DBFunctions().database;
    if (!await DBFunctions()
        .checkIfTableExists(db, DBFunctions.tableSalesBodySync)) {
      await db.execute('''
      CREATE TABLE ${DBFunctions.tableSalesBodySync} (
        id TEXT PRIMARY KEY,
        status INTEGER,
        update_date TEXT
      )
      ''');
    }
    final fetchedData = await db.query(DBFunctions.tableSalesBodySync,
        where: "status = ?", whereArgs: [0]);
    return fetchedData;
  }

  Future<bool> getSyncStatus(String id) async {
    final db = await DBFunctions().database;
    final data = await db.query(DBFunctions.tableSalesBodySync,
        where: "id = ?", whereArgs: [id]);
    if (data.isEmpty) return false;
    return data.first['status'] == 1;
  }
}
