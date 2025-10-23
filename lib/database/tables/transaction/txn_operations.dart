import 'dart:convert';
import 'dart:developer';
import 'package:ozone_erp/database/db_functions.dart';
import 'package:ozone_erp/models/device_details.dart';
import 'package:sqflite/sqflite.dart';
import '../../../models/sales_body.dart' as sb;
import '../../../models/voucher_body.dart';

class TxnOperations{
  Future<void> createNewSale({
    required sb.SalesBody salesBody,
    required List<sb.SalesItems> salesItems,
    required Billnumber billNumber,
  }) async {
    final db = await DBFunctions().database;
    String now = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      await db.transaction((txn) async {
        // Convert sales body to JSON and encode sales items as JSON string
        final body = salesBody.toJson();
        body['salesitems'] =
            jsonEncode(salesBody.salesitems?.map((e) => e.toJson()).toList());

        // Batch operation to optimize DB writes
        var batch = txn.batch();

        // Insert sales body
        batch.insert(DBFunctions.tableSalesBody, body,
            conflictAlgorithm: ConflictAlgorithm.replace);

        // Update stock quantities in a single batch
        for (var item in salesItems) {
          batch.rawUpdate(
            'UPDATE ${DBFunctions.tableItems} SET item_qty = item_qty - ? WHERE id = ?',
            [int.parse(item.quantity ?? '0'), item.itemId],
          );
        }

        // Insert sync entry
        batch.insert(
          DBFunctions.tableSalesBodySync,
          {'id': salesBody.id, 'status': 0, 'update_date': now},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        // Update bill number
        batch.update(
          DBFunctions.tableBillNumber,
          billNumber.toJson(),
          where: 'id = ?',
          whereArgs: [billNumber.id],
        );

        // Commit batch operations
        await batch.commit(noResult: true);
      });
    } catch (e) {
      print("Error in createNewSale: $e");
    }
  }

  Future<void> createNewOrder({
    required sb.SalesBody salesBody,
    required Billnumber billNumber,
  }) async {
    final db = await DBFunctions().database;
    String now = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      await db.transaction((txn) async {
        // Convert sales body to JSON and encode sales items as JSON string
        final body = salesBody.toJson();
        body['salesitems'] =
            jsonEncode(salesBody.salesitems?.map((e) => e.toJson()).toList());

        // Batch operation to optimize DB writes
        var batch = txn.batch();

        // Insert sales body
        batch.insert(DBFunctions.tableSalesBody, body,
            conflictAlgorithm: ConflictAlgorithm.replace);

        // Insert sync entry
        batch.insert(
          DBFunctions.tableSalesBodySync,
          {'id': salesBody.id, 'status': 0, 'update_date': now},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        // Update bill number
        batch.update(
          DBFunctions.tableBillNumber,
          billNumber.toJson(),
          where: 'id = ?',
          whereArgs: [billNumber.id],
        );

        // Commit batch operations
        await batch.commit(noResult: true);
      });
    } catch (e) {
      print("Error in createNewSale: $e");
    }
  }

  Future<void> createNewSaleVoucher({
    required VoucherBody voucher,
    required Billnumber billNumber,
  }) async {
    final db = await DBFunctions().database;
    String now = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      await db.transaction(
        (txn) async {
          Map<String, dynamic> push =
              voucher.copyWith(voucherId: voucher.vid).toJson();
          push['aeging'] = jsonEncode(voucher.aeging);
          var batch = txn.batch();
          batch.insert(DBFunctions.tableVouchers, push,
              conflictAlgorithm: ConflictAlgorithm.replace);
          batch.update(
            DBFunctions.tableBillNumber,
            billNumber.toJson(),
            where: 'id = ?',
            whereArgs: [billNumber.id],
          );
          batch.insert(DBFunctions.tableVoucherBodySync,
              {'id': voucher.vid, 'status': 0, 'update_date': now},
              conflictAlgorithm: ConflictAlgorithm.replace);

          await batch.commit(
            noResult: true,
          );
        },
      );
    } catch (e) {
      log(e.toString(), name: 'Error in creating voucher');
    }
  }
}
