import 'package:ozone_erp/database/db_functions.dart';
import 'package:ozone_erp/models/device_details.dart';
import 'package:sqflite/sqflite.dart';

class InsertDevice {
  Future<void> insertDevice(Device device) async {
    final db = await DBFunctions().database;
    await db.insert(DBFunctions.tableDevice, device.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Device>> getDevice() async {
    final db = await DBFunctions().database;
    final fetchedData = await db.query(DBFunctions.tableDevice);
    return fetchedData.map((e) => Device.fromJson(e)).toList();
  }

  Future<Device> getSingleDevice() async {
    final db = await DBFunctions().database;
    final fetchedData = await db.query(DBFunctions.tableDevice);
    return fetchedData.isEmpty ? Device() : Device.fromJson(fetchedData.first);
  }
}
