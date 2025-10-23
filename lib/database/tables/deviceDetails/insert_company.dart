import 'package:ozone_erp/data/app_data.dart';
import 'package:ozone_erp/database/db_functions.dart';
import 'package:ozone_erp/models/device_details.dart';
import 'package:sqflite/sqflite.dart';

class InsertCompany {
  Future<void> insertCompany(Company company) async {
    final db = await DBFunctions().database;
    await db.insert(DBFunctions.tableCompany, company.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    AppData().storeCompanyName(company.name!);
    AppData().storeCompanyEmail(company.email!);
  }

  Future<List<Company>> getCompany() async {
    final db = await DBFunctions().database;
    final fetchedData = await db.query(DBFunctions.tableCompany);
    return fetchedData.map((e) => Company.fromJson(e)).toList();
  }
}
