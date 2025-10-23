import 'package:ozone_erp/models/device_details.dart';
import 'package:sqflite/sqflite.dart';

import '../../db_functions.dart';

class InsertBillNumber {
  Future<void> insertBillNumber(Billnumber billNumber) async {
    final db = await DBFunctions().database;
    await db.insert(DBFunctions.tableBillNumber, billNumber.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Billnumber>> getBillNumber() async {
    final db = await DBFunctions().database;
    final fetchedData = await db.query(DBFunctions.tableBillNumber);
    return fetchedData.map((e) => Billnumber.fromJson(e)).toList();
  }

  Future<void> updateBillNumber(Billnumber billNumber) async {
    final db = await DBFunctions().database;
    await db.update(DBFunctions.tableBillNumber, billNumber.toJson(),
        where: 'id = ?', whereArgs: [billNumber.id]);
  }

  Future<Billnumber> getBillNumberByType(String type) async {
    final db = await DBFunctions().database;
    final fetchedData = await db.query(DBFunctions.tableBillNumber,
        where: '"transaction" = ?', whereArgs: [type]);
    return fetchedData.isEmpty
        ? Billnumber()
        : Billnumber.fromJson(fetchedData.first);
  }
}

class BillNumberTypes {
  static const String sales = 'sales';
  static const String purchase = 'purchase';
  static const String purchaseOrder = 'order';
  static const String salesReturn = 'sales_return';
  static const String purchaseReturn = 'purchase_return';
  static const String quickPayment = r'quickpayment';
  static const String quickReceipt = r'quickreceipt';
  static const String journal = 'jou';
  static const String contra = 'contra';
  static const String receipt = 'rec';
  static const String payment = 'pay';
  static const String order = 'estimate';
  static const String replacement = 'replacement';
  static const String deliveryNote = 'delivery_note';
  static const String creditNote = 'credit_note';
  static const String debitNote = 'debit_note';
  static const String picklist = 'picklist';
  static const String service = 'service';
  static const String quotation = 'quotation';
}
