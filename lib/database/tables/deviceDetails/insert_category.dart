import 'package:ozone_erp/models/device_details.dart';
import 'package:sqflite/sqflite.dart';

import '../../db_functions.dart';

class InsertCategory {
  Future<void> insertCategory(Category category) async {
    final db = await DBFunctions().database;
    await db.insert(DBFunctions.tableCategory, category.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Category>> getCategory() async {
    final db = await DBFunctions().database;
    final fetchedData = await db.query(DBFunctions.tableCategory);
    return fetchedData.map((json) => Category.fromJson(json)).toList();
  }

  Future<Category> getCategoryById(String id) async {
    final db = await DBFunctions().database;
    final fetchedData = await db
        .query(DBFunctions.tableCategory, where: "id = ?", whereArgs: [id]);
    return fetchedData.isEmpty
        ? Category()
        : Category.fromJson(fetchedData.first);
  }
}
