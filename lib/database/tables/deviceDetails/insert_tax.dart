import 'package:ozone_erp/database/db_functions.dart';
import 'package:ozone_erp/models/device_details.dart';
import 'package:sqflite/sqflite.dart';

class InsertTax {
  Future<void> insertTax(Tax tax) async {
    final db = await DBFunctions().database;
    await db.insert(DBFunctions.tableTax, tax.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Tax>> getTax() async {
    final db = await DBFunctions().database;
    final fetchedTax = await db.query(DBFunctions.tableTax);
    return fetchedTax.map((e) => Tax.fromJson(e)).toList();
  }

  Future<Tax> getTaxById(String id) async {
    final db = await DBFunctions().database;
    final fetchedTax = await db
        .query(DBFunctions.tableTax, where: 'gstid = ?', whereArgs: [id]);
    return fetchedTax.isEmpty ? Tax() : Tax.fromJson(fetchedTax.first);
  }
}
