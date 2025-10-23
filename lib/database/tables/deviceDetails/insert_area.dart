import 'package:ozone_erp/database/db_functions.dart';
import 'package:ozone_erp/models/device_details.dart';
import 'package:sqflite/sqflite.dart';

class InsertArea {
  Future<void> insertArea(Area area) async {
    final db = await DBFunctions().database;
    await db.insert(DBFunctions.tableArea, area.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Area>> getArea() async {
    final db = await DBFunctions().database;
    final fetchedAreas = await db.rawQuery('SELECT * FROM ${DBFunctions.tableArea}');
    return fetchedAreas.map((e) => Area.fromJson(e)).toList();
  }
}