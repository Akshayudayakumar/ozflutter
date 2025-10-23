import 'package:ozone_erp/database/db_functions.dart';
import 'package:ozone_erp/models/device_details.dart';
import 'package:sqflite/sqflite.dart';

class InsertAccLedgers {
  Future<void> insertAccLedgers(AccLedgers accLedgers) async {
    final db = await DBFunctions().database;
    await db.insert(DBFunctions.tableAccLedgers, accLedgers.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }
}