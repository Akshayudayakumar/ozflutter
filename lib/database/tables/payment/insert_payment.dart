import 'package:ozone_erp/database/db_functions.dart';
import 'package:ozone_erp/models/payment_model.dart';
import 'package:sqflite/sqflite.dart';

class InsertPayment {
  Future<void> insertPayment(PaymentModel payment) async {
    final db = await DBFunctions().database;
    await DBFunctions().createPaymentTable(db);
    await db.insert(DBFunctions.tablePayments, payment.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updatePayment(PaymentModel payment) async {
    final db = await DBFunctions().database;
    await db.update(DBFunctions.tablePayments, payment.toJson(),
        where: 'id = ?', whereArgs: [payment.id]);
  }

  Future<List<PaymentModel>> getPayments() async {
    final db = await DBFunctions().database;
    await DBFunctions().createPaymentTable(db);
    final data = await db.query(DBFunctions.tablePayments);
    return data
        .map(
          (e) => PaymentModel.fromJson(e),
        )
        .toList();
  }

  Future<List<PaymentModel>> getLimitedPayments(int limit, int offset) async {
    final db = await DBFunctions().database;
    await DBFunctions().createPaymentTable(db);
    final data =
        await db.query(DBFunctions.tablePayments, limit: limit, offset: offset);
    return data
        .map(
          (e) => PaymentModel.fromJson(e),
        )
        .toList();
  }
}
