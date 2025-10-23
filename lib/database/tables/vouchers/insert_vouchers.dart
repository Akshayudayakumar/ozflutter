import 'dart:convert';

import 'package:ozone_erp/database/db_functions.dart';
import 'package:ozone_erp/models/voucher_body.dart';
import 'package:sqflite/sqflite.dart';

class InsertVouchers {
  Future<void> insertVouchers(VoucherBody voucher) async {
    final db = await DBFunctions().database;
    if (!await DBFunctions()
        .checkIfTableExists(db, DBFunctions.tableVouchers)) {
      await DBFunctions().createVoucherTable(db);
    }
    Map<String, dynamic> push =
        voucher.copyWith(voucherId: voucher.vid).toJson();
    push['aeging'] = jsonEncode(voucher.aeging);
    await db.insert(DBFunctions.tableVouchers, push,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<VoucherBody>> getAllVouchers() async {
    final db = await DBFunctions().database;
    if (!await DBFunctions()
        .checkIfTableExists(db, DBFunctions.tableVouchers)) {
      return [];
    }
    final data = await db.query(DBFunctions.tableVouchers);
    return data
        .map(
          (e) => VoucherBody.fromJson(e),
        )
        .toList();
  }

  Future<VoucherBody> getVoucher(String id) async {
    final db = await DBFunctions().database;
    if (!await DBFunctions()
        .checkIfTableExists(db, DBFunctions.tableVouchers)) {
      return VoucherBody();
    }
    final data = await db
        .query(DBFunctions.tableVouchers, where: "vid = ?", whereArgs: [id]);
    if (data.isEmpty) {
      return VoucherBody();
    }
    return VoucherBody.fromJson(data.first);
  }

  Future<List<VoucherBody>> getVoucherByType(String type) async {
    final db = await DBFunctions().database;
    if (!await DBFunctions()
        .checkIfTableExists(db, DBFunctions.tableVouchers)) {
      return [];
    }
    final data = await db
        .query(DBFunctions.tableVouchers, where: "type = ?", whereArgs: [type]);
    return data
        .map(
          (e) => VoucherBody.fromJson(e),
        )
        .toList();
  }
}
