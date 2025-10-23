import 'package:ozone_erp/api/api.dart';
import 'package:ozone_erp/database/db_functions.dart';
import 'package:ozone_erp/models/device_details.dart';
import 'package:sqflite/sqflite.dart';

import '../../../data/app_data.dart';

class InsertCompanySettings {
  Future<void> insertCompanySettings(CompanySettings companySettings) async {
    final db = await DBFunctions().database;
    await db.insert(DBFunctions.tableCompanySettings, companySettings.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<CompanySettings>> getCompanySettings() async {
    final db = await DBFunctions().database;
    final fetchedData = await db.query(DBFunctions.tableCompanySettings);
    return fetchedData.map((e) => CompanySettings.fromJson(e)).toList();
  }

  Future<void> storeCompanyLogo() async {
    final db = await DBFunctions().database;
    final fetchedData = await db.query(DBFunctions.tableCompanySettings);
    final companySettings = CompanySettings.fromJson(fetchedData.first);
    AppData().storeCompanyLogo(
        '${BackEnd.baseUrl}uploads/company/${companySettings.logo ?? ''}');
  }
}
