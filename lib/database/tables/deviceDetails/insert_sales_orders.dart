import 'package:ozone_erp/database/db_functions.dart';
import 'package:ozone_erp/models/device_details.dart';
import 'package:sqflite/sqflite.dart';

class InsertSalesOrders {
  Future<void> insertSalesOrder(SalesOrders order) async {
    final db = await DBFunctions().database;
    if (!await DBFunctions()
        .checkIfTableExists(db, DBFunctions.tableSalesOrders)) {
      await DBFunctions().createSaleOrderTable(db);
    }
    if (!await DBFunctions()
        .checkIfTableExists(db, DBFunctions.tableSalesItems)) {
      await DBFunctions().createSaleItemTable(db);
    }
    await db.transaction((txn) async {
      final orderMap = order.toJson();
      orderMap.remove('sales_items');
      await txn.insert(DBFunctions.tableSalesOrders, orderMap,
          conflictAlgorithm: ConflictAlgorithm.replace);

      // Insert each sales item into sales_items table
      for (var item in order.salesItems ?? <SalesItems>[]) {
        Map<String, dynamic> itemMap = item.toJson();
        itemMap["sales_id"] = order.salesId; // Ensure correct foreign key
        await txn.insert(DBFunctions.tableSalesItems, itemMap,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
  }

  Future<void> insertSalesOrderList(List<SalesOrders> orders) async {
    final db = await DBFunctions().database;
    await db.transaction(
      (txn) async {
        var batch = txn.batch();
        for (var order in orders) {
          final orderMap = order.toJson();
          orderMap.remove('sales_items');
          batch.insert(DBFunctions.tableSalesOrders, orderMap,
              conflictAlgorithm: ConflictAlgorithm.replace);
          for (var item in order.salesItems ?? <SalesItems>[]) {
            Map<String, dynamic> itemMap = item.toJson();
            itemMap["sales_id"] = order.salesId;
            batch.insert(DBFunctions.tableSalesItems, itemMap,
                conflictAlgorithm: ConflictAlgorithm.replace);
          }
        }
        await batch.commit(noResult: true);
      },
    );
  }

  Future<List<SalesOrders>> getSalesOrders() async {
    final db = await DBFunctions().database;
    final fetchedData = await db.query(DBFunctions.tableSalesOrders);
    final items = fetchedData
        .map(
          (e) => SalesOrders.fromJson(e),
        )
        .toList();
    List<SalesOrders> orders = [];
    for (var item in items) {
      orders.add(await getSalesOrderWithItems(item.salesId ?? ''));
    }
    return orders;
  }

  Future<SalesOrders> getSalesOrderById(String id) async {
    final db = await DBFunctions().database;
    final fetchedData = await db
        .query(DBFunctions.tableSalesOrders, where: "id = ?", whereArgs: [id]);
    return fetchedData.isEmpty
        ? SalesOrders()
        : SalesOrders.fromJson(fetchedData);
  }

  Future<SalesOrders> getSalesOrderWithItems(String salesId) async {
    final db = await DBFunctions().database;

    // Fetch the sales order
    final List<Map<String, dynamic>> salesOrderMaps = await db.query(
      DBFunctions.tableSalesOrders,
      where: 'sales_id = ?',
      whereArgs: [salesId],
    );

    if (salesOrderMaps.isEmpty) return SalesOrders(); // No order found

    // Convert sales order to SalesOrders object
    SalesOrders order = SalesOrders.fromJson(salesOrderMaps.first);

    // Fetch associated sales items
    final List<Map<String, dynamic>> salesItemMaps = await db.query(
      DBFunctions.tableSalesItems,
      where: 'sales_id = ?',
      whereArgs: [salesId],
    );

    // Convert sales items to a list
    List<SalesItems> salesItems =
        salesItemMaps.map((map) => SalesItems.fromJson(map)).toList();

    // Attach items to the order
    order = order.copyWith(salesItems: salesItems);

    return order;
  }
}
