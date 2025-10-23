import 'package:sqflite/sqflite.dart';

import '../../../models/device_details.dart';
import '../../db_functions.dart';

class InsertUnit {
  Future<void> insertUnit(Unit unit) async {
    final db = await DBFunctions().database;
    await db.insert(DBFunctions.tableUnit, unit.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Unit>> getUnits() async {
    final db = await DBFunctions().database;
    final fetchedData = await db.query(DBFunctions.tableUnit);
    return fetchedData.map((json) => Unit.fromJson(json)).toList();
  }
}
