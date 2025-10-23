import 'package:sqflite/sqflite.dart';
import '../../../models/device_details.dart';
import '../../db_functions.dart';

class InsertAccType {
  Future<void> insertAccType(AccType accType) async {
    final db = await DBFunctions().database;
    await db.insert(DBFunctions.tableAccType, accType.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }
}