import 'dart:convert';

import 'package:ozone_erp/models/sales_body.dart';
import 'package:sqflite/sqflite.dart';

import '../../db_functions.dart';

class InsertSalesReturnBody {
  Future<void> insertSalesReturnBody(SalesBody salesReturnBody) async {
    final db = await DBFunctions().database;
    if (!await DBFunctions()
        .checkIfTableExists(db, DBFunctions.tableSalesReturnBody)) {
      await DBFunctions().createSalesReturnBodyTable(db);
    }
    final body = salesReturnBody.toJson();
    body['salesitems'] =
        jsonEncode(salesReturnBody.salesitems?.map((e) => e.toJson()).toList());
    await db.insert(DBFunctions.tableSalesReturnBody, body,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<SalesBody>> getSalesReturnBody() async {
    final db = await DBFunctions().database;
    final fetchedData = await db.query(DBFunctions.tableSalesReturnBody);
    return fetchedData.map((e) => SalesBody.fromJson(e)).toList();
  }

  Future<void> updateSalesReturnBody(SalesBody salesReturnBody) async {
    final db = await DBFunctions().database;
    await db.update(DBFunctions.tableSalesReturnBody, salesReturnBody.toJson(),
        where: 'id = ?', whereArgs: [salesReturnBody.id]);
  }

  Future<void> deleteSalesReturnBody() async {
    final db = await DBFunctions().database;
    await db.delete(DBFunctions.tableSalesReturnBody);
  }
}
