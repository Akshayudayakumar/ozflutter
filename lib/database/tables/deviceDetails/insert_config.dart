import 'package:ozone_erp/models/device_details.dart';
import 'package:sqflite/sqflite.dart';

import '../../db_functions.dart';

class InsertConfig {
  Future<void> insertConfig(Config config) async {
    final db = await DBFunctions().database;
    Map<String, dynamic> changedConfig = config.toJson();
    changedConfig['is_taxincluded'] = config.isTaxincluded! ? '1' : '0';
    await db.insert(DBFunctions.tableConfig, changedConfig, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Config> getConfig() async {
    final db = await DBFunctions().database;
    final fetchedConfig = await db.query(DBFunctions.tableConfig);
    return Config.fromJson(fetchedConfig.first);
  }

}