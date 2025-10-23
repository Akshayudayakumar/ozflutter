import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:ozone_erp/database/db_functions.dart';
import 'package:ozone_erp/models/sale_types.dart';
import 'package:sqflite/sqflite.dart';

import '../../../models/sales_body.dart';

class InsertSalesBody {
  Future<void> insertSalesBody(SalesBody salesBody) async {
    final db = await DBFunctions().database;
    if (!await DBFunctions()
        .checkIfTableExists(db, DBFunctions.tableSalesBody)) {
      await DBFunctions().createSalesBodyTable(db);
    }
    final body = salesBody.toJson();
    body['salesitems'] =
        jsonEncode(salesBody.salesitems?.map((e) => e.toJson()).toList());
    await db.insert(DBFunctions.tableSalesBody, body,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<SalesBody>> getSalesBody() async {
    final db = await DBFunctions().database;
    if (!await DBFunctions()
        .checkIfTableExists(db, DBFunctions.tableSalesBody)) {
      await DBFunctions().createSalesBodyTable(db);
    }
    final fetchedData = await db.query(DBFunctions.tableSalesBody);
    return fetchedData.map((e) => SalesBody.fromJson(e)).toList();
  }

  Future<SalesBody?> getSalesBodyById(String id) async {
    final db = await DBFunctions().database;
    if (!await DBFunctions()
        .checkIfTableExists(db, DBFunctions.tableSalesBody)) {
      await DBFunctions().createSalesBodyTable(db);
    }
    final fetchedData = await db
        .query(DBFunctions.tableSalesBody, where: 'id = ?', whereArgs: [id]);
    if (fetchedData.isEmpty) return null;
    return SalesBody.fromJson(fetchedData.first);
  }

  Future<Either<List<SalesBody>, SalesBody>> getSalesBodyByInvoice(
      String invoice,
      [String type = SaleTypes.sales]) async {
    final db = await DBFunctions().database;
    if (!await DBFunctions()
        .checkIfTableExists(db, DBFunctions.tableSalesBody)) {
      await DBFunctions().createSalesBodyTable(db);
    }
    String lowerInvoice = invoice.trim().toLowerCase();
    final fetchedData = await db.rawQuery(
        'SELECT * FROM ${DBFunctions.tableSalesBody} WHERE LOWER(invoice) LIKE ? AND type = ?',
        ['%$lowerInvoice%', type]);
    if (fetchedData.isEmpty) return Right(SalesBody());
    if (fetchedData.length > 1) {
      return Left(fetchedData.map((e) => SalesBody.fromJson(e)).toList());
    }
    return Right(SalesBody.fromJson(fetchedData.first));
  }

  Future<List<SalesBody>> getSalesBodyByType(String type) async {
    final db = await DBFunctions().database;
    if (!await DBFunctions()
        .checkIfTableExists(db, DBFunctions.tableSalesBody)) {
      await DBFunctions().createSalesBodyTable(db);
    }
    final fetchedData = await db.query(DBFunctions.tableSalesBody,
        where: 'type = ?', whereArgs: [type]);
    return fetchedData.map((e) => SalesBody.fromJson(e)).toList();
  }

  Future<void> updateSalesBody(SalesBody salesBody) async {
    final db = await DBFunctions().database;
    final body = salesBody.toJson();
    body['salesitems'] =
        jsonEncode(salesBody.salesitems?.map((e) => e.toJson()).toList());
    await db.update(DBFunctions.tableSalesBody, body,
        where: 'id = ?', whereArgs: [salesBody.id]);
  }

  Future<void> deleteSalesBody() async {
    final db = await DBFunctions().database;
    await db.delete(DBFunctions.tableSalesBody);
  }
}
