import 'package:ozone_erp/models/device_details.dart';
import 'package:sqflite/sqflite.dart';

import '../../db_functions.dart';

class InsertAccSubType {
  Future<void> insertAccSubType(AccSubType accSubType) async {
    final db = await DBFunctions().database;
    await db.insert(DBFunctions.tableAccSubType, accSubType.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }
}