import 'package:ozone_erp/models/general_details.dart';
import 'package:sqflite/sqflite.dart';

import '../../db_functions.dart';

class InsertCustomers {
  Future<void> insertCustomers(Customers customers) async {
    final db = await DBFunctions().database;
    await db.insert(DBFunctions.tableCustomers, customers.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertCustomersBatch(List<Customers> customers) async {
    final db = await DBFunctions().database;
    final batch = db.batch();
    for (var customer in customers) {
      batch.insert(DBFunctions.tableCustomers, customer.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    batch.commit(noResult: true);
  }

  Future<List<Customers>> getCustomers() async {
    final db = await DBFunctions().database;
    final fetchedCustomers =
        await db.rawQuery('SELECT * FROM ${DBFunctions.tableCustomers}');
    return fetchedCustomers
        .map((customer) => Customers.fromJson(customer))
        .toList();
  }

  Future<void> updateCustomer(Customers customer) async {
    final db = await DBFunctions().database;
    await db.update(DBFunctions.tableCustomers, customer.toJson(),
        where: 'id = ?', whereArgs: [customer.id]);
  }

  Future<Customers> getCustomerById(String id) async {
    final db = await DBFunctions().database;
    final fetchedCustomer = await db
        .query(DBFunctions.tableCustomers, where: 'id = ?', whereArgs: [id]);
    return fetchedCustomer.isEmpty
        ? Customers()
        : Customers.fromJson(fetchedCustomer.first);
  }
}
