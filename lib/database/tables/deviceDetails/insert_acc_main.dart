import 'package:ozone_erp/models/device_details.dart';
import 'package:sqflite/sqflite.dart';
import '../../db_functions.dart';

class InsertAccMain {
  Future<void> insertAccMain(AccMain accMain) async {
    final db = await DBFunctions().database;
    await db.insert(DBFunctions.tableAccMain, accMain.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }
}