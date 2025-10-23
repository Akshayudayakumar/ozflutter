import 'package:ozone_erp/models/device_details.dart';
import 'package:sqflite/sqflite.dart';

import '../../db_functions.dart';

class InsertPointSettings {
  Future<void> insertPointSettings(PointSettings pSettings) async {
    final db = await DBFunctions().database;

    await db.insert(DBFunctions.tablePointSettings, pSettings.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }
}