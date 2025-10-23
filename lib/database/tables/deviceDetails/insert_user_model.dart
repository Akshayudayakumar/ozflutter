import 'package:ozone_erp/database/db_functions.dart';
import 'package:sqflite/sqflite.dart';

import '../../../models/user_model.dart';

class InsertUserModel {
  String tableName = "user_model";

  Future<void> createUserModelTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $tableName (
    id TEXT PRIMARY KEY,
    user_name TEXT,
    user_type TEXT,
    user_address TEXT,
    user_mobile TEXT,
    user_phone TEXT,
    user_email TEXT,
    username TEXT,
    percentage TEXT,
    user_password TEXT,
    company TEXT,
    'is_active' TEXT,
    is_hide TEXT,
    branch TEXT,
    updatedate TEXT
)''');
  }

  Future<void> insertUserModel(UserModel userModel) async {
    final db = await DBFunctions().database;
    if (await DBFunctions().checkIfTableExists(db, tableName)) {
      await db.execute('DROP TABLE IF EXISTS $tableName');
      await createUserModelTable(db);
    } else {
      await createUserModelTable(db);
    }
    Map<String, dynamic> json = userModel.toJson();
    json['is_active'] = userModel.isActive;
    if (json.containsKey('is-active')) {
      json.remove('is-active');
    }
    await db.insert(tableName, json);
  }

  Future<UserModel?> getUserModel() async {
    final db = await DBFunctions().database;
    if(!await DBFunctions().checkIfTableExists(db, tableName)) {
      await createUserModelTable(db);
    }
    final fetchedUsers = await db.rawQuery('SELECT * FROM $tableName');
    if(fetchedUsers.isEmpty) return null;
    return UserModel.fromJson(fetchedUsers.first);
  }
}
