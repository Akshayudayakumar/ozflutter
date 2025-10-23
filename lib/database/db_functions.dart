import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/Constants/constant.dart';
import 'package:ozone_erp/utils/utils.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

enum CopyClass{ replace, newFile, skip }

/// Singleton class to handle database operations
class DBFunctions {
  static final DBFunctions _instance = DBFunctions._();
  static Database? _database;

  DBFunctions._(); // Private constructor for singleton pattern

  factory DBFunctions() => _instance;

  /// Retrieves the SQLite database instance, initializing it if necessary.
  ///
  /// This getter ensures that a single instance of the database is used
  /// throughout the application. If the database is already initialized,
  /// it returns the existing instance. Otherwise, it initializes the database
  /// by calling `_initDatabase()`.
  ///
  /// ### Example:
  /// ```dart
  /// Database db = await database;
  /// ```
  ///
  /// - Returns: A `Future<Database>` representing the SQLite database instance.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initializes and opens the SQLite database.
  ///
  /// This function retrieves the database file path and opens the database,
  /// creating it if it does not exist. The database is initialized with the
  /// specified version and creation callback.
  ///
  /// ### Process:
  /// 1. Gets the database directory path using `getDatabasesPath()`.
  /// 2. Joins the path with the database name [dbName].
  /// 3. Opens the database using `openDatabase()`, calling [_onCreate] if it needs to be created.
  ///
  /// ### Example:
  /// ```dart
  /// Database db = await _initDatabase();
  /// ```
  ///
  /// - Returns: A `Future<Database>` instance representing the opened database.
  Future<Database> _initDatabase() async {
    // Get the database file path
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    // Open or create the database
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  //DB Name
  static const String dbName = 'app_database.db';
  static const String importedDbName = 'imported_db.db';

  //DB Path
  static const String dbPath =
      '/storage/emulated/0/Download/Ozone ERP/Databases';

  //TODO: Tables to create: Company Settings, Config, Company, Device, Point Settings, Tax, Unit, Category, Area, Sales Orders, Bill Number, AccType, AccSubType, AccMain, AccLedgers

  //TODO: General Details tables: Items, Customers, Price List, Price List Details

  static const String tableCompanySettings = 'company_settings';
  static const String tableConfig = 'config';
  static const String tableCompany = 'company';
  static const String tableDevice = 'device';
  static const String tablePointSettings = 'point_settings';
  static const String tableTax = 'tax';
  static const String tableUnit = 'unit';
  static const String tableCategory = 'category';
  static const String tableArea = 'area';
  static const String tableSalesOrders = 'sales_orders';
  static const String tableBillNumber = 'bill_number';
  static const String tableAccType = 'acc_type';
  static const String tableAccSubType = 'acc_sub_type';
  static const String tableAccMain = 'acc_main';
  static const String tableAccLedgers = 'acc_ledgers';
  static const String tableSalesItems = 'sales_items';
  static const String tableItems = 'items';
  static const String tableCustomers = 'customers';
  static const String tablePriceList = 'price_list';
  static const String tablePriceListDetails = 'price_list_details';
  static const String tableMenuItems = 'menu_items';
  static const String tableSalesBody = 'sales_body';
  static const String tableSalesReturnBody = 'sales_return_body';
  static const String tableSalesBodySync = 'sales_body_sync';
  static const String tableVoucherBodySync = 'voucher_body_sync';
  static const String tableVouchers = 'voucher';
  static const String tablePayments = 'payments';
  static const String returnLog = 'return_log';

  //Create a table

  static Future<void> createTable(
      Database db, String tableName, Map<String, String> columns) async {
    String columnsDef =
        columns.entries.map((e) => '${e.key} ${e.value}').join(', ');
    await db.execute('CREATE TABLE IF NOT EXISTS $tableName ($columnsDef)');
  }

  //General Details

  Future<void> createItemsTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $tableItems (
      id TEXT PRIMARY KEY,
      hsncodename TEXT,
      price_discount TEXT,
      price_list_rate TEXT,
      price_list_id TEXT,
      category TEXT,
      item_category_id TEXT,
      sub_unit_one TEXT,
      sub_unit_two TEXT,
      itemgodownid TEXT,
      free_qty TEXT,
      free_qty_for TEXT,
      part_no TEXT,
      make_model TEXT,
      item_size_id TEXT,
      brand_id TEXT,
      barcode TEXT,
      price_code TEXT,
      item_group_id TEXT,
      unit_id TEXT,
      prate TEXT,
      srate TEXT,
      wh_rate TEXT,
      special_rate TEXT,
      MRP TEXT,
      open_stk_rate TEXT,
      commission TEXT,
      tax_id TEXT,
      tax_ledger_id TEXT,
      tax_sales_id TEXT,
      tax_purchase_id TEXT,
      published TEXT,
      hsncode TEXT,
      item_type_id TEXT,
      godown TEXT,
      description TEXT,
      mfg_date TEXT,
      exp_date TEXT,
      updatedate TEXT,
      cess_id TEXT,
      name TEXT,
      ces_name TEXT,
      ces_id TEXT,
      ces_percent TEXT,
      batch TEXT,
      godown_id TEXT,
      item_id TEXT,
      item_qty TEXT,
      item_srate TEXT,
      item_prate TEXT,
      item_whrate TEXT,
      item_mrp TEXT,
      item_opnstkrate TEXT,
      type TEXT,
      current_stock TEXT,
      open_stock TEXT
    )
  ''');
  }

  Future<void> createCustomersTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $tableCustomers (
      id TEXT PRIMARY KEY,
      lead_ref_id TEXT,
      supplier_main_id TEXT,
      name TEXT,
      code TEXT,
      longitude TEXT,
      latitude TEXT,
      phone TEXT,
      total_points TEXT,
      redeemed_points TEXT,
      cus_agent TEXT,
      cus_salesman TEXT,
      cus_rate TEXT,
      contact_person TEXT,
      contact_number TEXT,
      tin TEXT,
      cst TEXT,
      gst TEXT,
      district TEXT,
      branch TEXT,
      customer_type TEXT,
      email TEXT,
      password TEXT,
      address_line1 TEXT,
      address_line2 TEXT,
      details TEXT,
      type TEXT,
      listed_in_supplier TEXT,
      published TEXT,
      credit_period TEXT,
      credit_period_exceed TEXT,
      credit_amount TEXT,
      credit_amount_exceed TEXT,
      bank TEXT,
      account_no TEXT,
      ifsc_code TEXT,
      area TEXT,
      route TEXT,
      location TEXT,
      price_list TEXT,
      updatedate TEXT,
      name_lan TEXT,
      address_line1_lan TEXT,
      address_line2_lan TEXT,
      pincode TEXT,
      is_active TEXT
    )
  ''');
  }

  Future<void> createPriceListTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $tablePriceList (
      id TEXT PRIMARY KEY,
      price_list TEXT,
      note TEXT,
      published TEXT
    )
  ''');
  }

  Future<void> createPriceListDetailsTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $tablePriceListDetails (
      id TEXT PRIMARY KEY,
      price_list TEXT,
      note TEXT,
      published TEXT,
      price_list_id TEXT,
      item_id TEXT,
      batch TEXT,
      sales_rate TEXT,
      price_discount TEXT,
      price_discount_amount TEXT
    )
  ''');
  }

  //Device Details

  Future<void> createCompanySettingsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableCompanySettings (
        com_id TEXT PRIMARY KEY,
  is_main TEXT,
  name TEXT,
  comkey TEXT,
  whatsapp_status TEXT,
  retail_store_id TEXT,
  logo TEXT,
  is_multiplegodown TEXT,
  address TEXT,
  pincode TEXT,
  location TEXT,
  phone TEXT,
  tin TEXT,
  FSSAI TEXT,
  details TEXT,
  menutype TEXT,
  company_master TEXT,
  email TEXT,
  name_lan TEXT,
  address_lan TEXT,
  updatedate TEXT,
  billwise_opening TEXT,
  com_tax_type TEXT,
  is_location TEXT,
  is_discription TEXT,
  item_transfer_bill TEXT,
  is_billtype TEXT,
  is_cess TEXT,
  is_production TEXT,
  item_transfer_bills TEXT,
  is_taxincluded TEXT,
  is_itemcode TEXT,
  is_ageing TEXT,
  is_analytics TEXT,
  is_costcenter TEXT,
  is_bankac TEXT,
  is_batch TEXT,
  barcode_settings TEXT,
  item_image TEXT,
  price_margin TEXT,
  quantity_price TEXT,
  item_video TEXT,
  lc_auto_update TEXT,
  additional_cess TEXT,
  item_alternate TEXT,
  is_supplier TEXT,
  is_multipletax TEXT,
  is_part_no TEXT,
  sj_unit_cost TEXT,
  is_item_type TEXT,
  is_godown TEXT,
  is_makemodel TEXT,
  is_confirm TEXT,
  is_unit TEXT,
  item_rack TEXT,
  item_commission TEXT,
  commission_type TEXT,
  item_min_rate TEXT,
  item_advanced TEXT,
  is_autobarcode TEXT,
  is_size TEXT,
  barcode_preffix TEXT,
  auto_barcode TEXT,
  is_feature TEXT,
  is_itemqrcode TEXT,
  export_invoice TEXT,
  onsync_discount TEXT,
  onsync_cusrate TEXT,
  show_criterion TEXT,
  is_rawmaterial TEXT,
  is_adjustment TEXT,
  print_size TEXT,
  round_off TEXT,
  enable_barcode TEXT,
  sale_cash_type TEXT,
  is_freequantity TEXT,
  discount_on TEXT,
  global_mrp TEXT,
  global_mrp_value TEXT,
  global_discount TEXT,
  is_kitgroup TEXT,
  customer_points TEXT,
  is_kitcustomer TEXT,
  is_cash_collection TEXT,
  is_composite TEXT,
  is_bkground_print TEXT,
  bill_mrp TEXT,
  is_return_damage TEXT,
  is_IMEI TEXT,
  pur_cash_type TEXT,
  c2 TEXT,
  comset_currency TEXT,
  currency_symbol TEXT,
  comset_bank TEXT,
  comset_account_no TEXT,
  comset_ifsccode TEXT,
  crm_type TEXT,
  comset_statecode TEXT,
  terms_condition TEXT,
  comset_declaration TEXT,
  opening_aeging TEXT,
  new TEXT,
  select_master TEXT,
  paper_orientation TEXT
      )
    ''');
  }

  Future<void> createCompanyTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $tableCompany (
    address TEXT,
    com_id TEXT PRIMARY KEY,
    name TEXT,
    comkey TEXT,
    is_multiplegodown TEXT,
    phone TEXT,
    tin TEXT,
    details TEXT,
    menutype TEXT,
    company_master TEXT,
    email TEXT,
    name_lan TEXT,
    address_lan TEXT,
    updatedate TEXT,
    billwise_opening TEXT,
    com_tax_type TEXT,
    is_location TEXT,
    is_discription TEXT,
    item_transfer_bill TEXT,
    is_billtype TEXT,
    is_cess TEXT,
    is_production TEXT,
    item_transfer_bills TEXT,
    is_taxincluded TEXT,
    is_itemcode TEXT,
    is_ageing TEXT,
    is_analytics TEXT,
    is_costcenter TEXT,
    is_bankac TEXT,
    is_batch TEXT,
    barcode_settings TEXT,
    item_image TEXT,
    price_margin TEXT,
    quantity_price TEXT,
    item_video TEXT,
    lc_auto_update TEXT,
    additional_cess TEXT,
    item_alternate TEXT,
    is_supplier TEXT,
    is_multipletax TEXT,
    is_part_no TEXT,
    sj_unit_cost TEXT,
    is_item_type TEXT,
    is_godown TEXT,
    is_makemodel TEXT,
    is_confirm TEXT,
    is_unit TEXT,
    item_rack TEXT,
    item_commission TEXT,
    commission_type TEXT,
    item_min_rate TEXT,
    item_advanced TEXT,
    is_autobarcode TEXT,
    is_size TEXT,
    barcode_preffix TEXT,
    auto_barcode TEXT,
    is_feature TEXT,
    is_itemqrcode TEXT,
    export_invoice TEXT,
    onsync_discount TEXT,
    onsync_cusrate TEXT,
    show_criterion TEXT,
    is_rawmaterial TEXT,
    is_adjustment TEXT,
    print_size TEXT,
    round_off TEXT,
    enable_barcode TEXT,
    sale_cash_type TEXT,
    is_freequantity TEXT,
    discount_on TEXT,
    global_mrp TEXT,
    global_mrp_value TEXT,
    global_discount TEXT,
    is_kitgroup TEXT,
    customer_points TEXT,
    is_kitcustomer TEXT,
    is_cash_collection TEXT,
    is_composite TEXT,
    is_bkground_print TEXT,
    bill_mrp TEXT,
    is_return_damage TEXT,
    is_IMEI TEXT,
    pur_cash_type TEXT,
    c2 TEXT,
    comset_currency TEXT,
    currency_symbol TEXT,
    comset_bank TEXT,
    comset_account_no TEXT,
    comset_ifsccode TEXT,
    crm_type TEXT,
    comset_statecode TEXT,
    terms_condition TEXT,
    comset_declaration TEXT,
    opening_aeging TEXT,
    new TEXT,
    select_master TEXT,
    paper_orientation TEXT
)

    ''');
  }

  Future<void> createPointSettingsTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $tablePointSettings (
    id TEXT PRIMARY KEY,
    min_point_to_redeem TEXT,
    one_currency_equivalent TEXT,
    one_point_equivalent TEXT
)
    ''');
  }

  Future<void> createTaxTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $tableTax (
    gstid TEXT PRIMARY KEY,
    cgst TEXT,
    sgst TEXT,
    igst TEXT,
    GST TEXT,
    cess_type TEXT,
    published TEXT,
    updatedate TEXT,
    ces_name TEXT,
    ces_percent TEXT,
    ces_id TEXT
)
    ''');
  }

  Future<void> createUnitTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $tableUnit (
    unit_id TEXT PRIMARY KEY,
    id TEXT,
    name TEXT,
    code TEXT,
    unit_count TEXT,
    published TEXT,
    updatedate TEXT,
    name_lan TEXT
)
    ''');
  }

  Future<void> createCategoryTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $tableCategory (
    id TEXT PRIMARY KEY,
    category_main_id TEXT,
    name TEXT,
    discount TEXT,
    item_type_id TEXT,
    item_category_id TEXT,
    category_tax TEXT,
    category_hsncode TEXT,
    published TEXT,
    updatedate TEXT,
    image TEXT,
    name_lan TEXT
)
    ''');
  }

  Future<void> createSaleOrderTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $tableSalesOrders (
    sales_id TEXT PRIMARY KEY,
    invoice TEXT,
    remarks TEXT,
    device_id TEXT,
    invoice_date TEXT,
    due_date TEXT,
    delivery_date TEXT,
    credit_eod TEXT,
    total TEXT,
    dollar_value TEXT,
    packing_details TEXT,
    receipt_amount TEXT,
    cess TEXT,
    additional_cess TEXT,
    cash_amount TEXT,
    bank_amount TEXT,
    bank_id TEXT,
    bank_pay_method TEXT,
    gpay_no TEXT,
    card_no TEXT,
    bank_ref TEXT,
    tax TEXT,
    buyer_order_no TEXT,
    other_ref TEXT,
    delivery_amt TEXT,
    pay_amt TEXT,
    tax_id TEXT,
    is_mobile TEXT,
    is_assigned TEXT,
    is_synced TEXT,
    other TEXT,
    freight TEXT,
    advance TEXT,
    discount TEXT,
    redeemed_amount TEXT,
    redeemed_points TEXT,
    global_mrp TEXT,
    roundoff TEXT,
    ref_id TEXT,
    ref_amount TEXT,
    sales_ref TEXT,
    manager_id TEXT,
    sales_man_id TEXT,
    created_date TEXT,
    narration TEXT,
    created_by TEXT,
    type TEXT,
    bill_type TEXT,
    paper_size TEXT,
    bill_margin TEXT,
    published TEXT,
    shipping_terms TEXT,
    payment_term TEXT,
    customer_id TEXT,
    longitude TEXT,
    latitude TEXT,
    estimate_id TEXT,
    status TEXT,
    sales_status TEXT,
    cash_type TEXT,
    cash_status TEXT,
    printtype TEXT,
    area TEXT,
    route TEXT,
    location TEXT,
    vehicle TEXT,
    salesman TEXT,
    packed_by TEXT,
    cusname TEXT,
    cusgst TEXT,
    cusstate TEXT,
    collected_amount TEXT,
    adjustment_amount TEXT,
    adjustment_ref TEXT,
    ewb_no TEXT,
    ref_no TEXT,
    buyer TEXT,
    pre_carriage TEXT,
    place_of_receipt TEXT,
    flight_no TEXT,
    port_of_landing TEXT,
    port_of_discharge TEXT,
    final_destination TEXT,
    country_final_destination TEXT,
    country_origin_of_goods TEXT,
    transport_mode TEXT,
    place TEXT,
    vehicle_no TEXT,
    con_name TEXT,
    con_addr TEXT,
    con_contact TEXT,
    con_gst TEXT,
    con_state TEXT,
    ewb_details TEXT,
    terms_condition TEXT,
    despatch_details TEXT,
    cusdetails TEXT,
    cusemail TEXT,
    cost_center TEXT,
    updatedate TEXT,
    distance TEXT,
    e_invoice_status TEXT,
    e_way_status TEXT,
    loylty_id TEXT,
    loylty_amount TEXT,
    saletype TEXT,
    print_status TEXT
)
    ''');
  }

  Future<void> createSaleItemTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $tableSalesItems (
    sal_itms_id TEXT PRIMARY KEY,
    sales_id TEXT,
    sales_ref_type TEXT,
    sales_ref_id TEXT,
    emei TEXT,
    emei_pur_id TEXT,
    item_id TEXT,
    item_landing_cost TEXT,
    batch TEXT,
    size_id TEXT,
    unit_id TEXT,
    free_unit_id TEXT,
    base_unit_id TEXT,
    quantity TEXT,
    SQFTNO TEXT,
    ItemSQFT TEXT,
    cartel_wt TEXT,
    cartel_no TEXT,
    base_quantity TEXT,
    unit_qty TEXT,
    base_free_quantity TEXT,
    base_damage_quantity TEXT,
    actual_quantity TEXT,
    damage_quantity TEXT,
    free_qty TEXT,
    free_quantity TEXT,
    itm_fre_qty TEXT,
    itm_fre_qty_for TEXT,
    estimate_quantity TEXT,
    rate TEXT,
    ces TEXT,
    itm_ces_id TEXT,
    itm_ces_name TEXT,
    itm_ces_per TEXT,
    itm_raw_ces TEXT,
    ces_amt TEXT,
    mrp TEXT,
    salemrp TEXT,
    item_rate TEXT,
    item_margin TEXT,
    mar_pur_rate TEXT,
    item_commission TEXT,
    godown TEXT,
    analytics TEXT,
    tax_id TEXT,
    tax TEXT,
    is_taxincluded TEXT,
    discount TEXT,
    total TEXT,
    published TEXT,
    updatedate TEXT,
    dis_amt TEXT,
    add_dis_per TEXT,
    add_dis_amt TEXT,
    item_discription TEXT,
    delivered_qty TEXT,
    item_name TEXT,
    FOREIGN KEY (sales_id) REFERENCES sales(sales_id)
)''');
  }

  Future<void> createBillTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $tableBillNumber (
    id TEXT PRIMARY KEY,
    is_pos TEXT,
    is_return_damage TEXT,
    type TEXT,
    print_type TEXT,
    branch_id TEXT,
    startnumber TEXT,
    seperator TEXT,
    suffix TEXT,
    preffix TEXT,
    "transaction" TEXT,
    cash TEXT,
    bank TEXT,
    godown_id TEXT,
    set_rate TEXT,
    updatedate TEXT,
    name_lan TEXT)''');
  }

  Future<void> createAccTypeTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $tableAccType (
    id TEXT PRIMARY KEY,
    name TEXT,
    type_code TEXT,
    published TEXT,
    updatedate TEXT,
    name_lan TEXT
)
    ''');
  }

  Future<void> createAccSubTypeTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $tableAccSubType (
    id TEXT PRIMARY KEY,
    name TEXT,
    name_lan TEXT,
    sub_code TEXT,
    code TEXT,
    acc_type_id TEXT,
    published TEXT,
    updatedate TEXT
)
    ''');
  }

  Future<void> createAccMainTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $tableAccMain (
    id TEXT PRIMARY KEY,
    name TEXT,
    code TEXT,
    branch_id TEXT,
    acc_sub_type_id TEXT,
    published TEXT,
    updatedate TEXT,
    name_lan TEXT
)
    ''');
  }

  Future<void> createAccLedgerTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $tableAccLedgers (
    id TEXT PRIMARY KEY,
    fin_sync_id TEXT,
    ledger_main_id TEXT,
    name TEXT,
    acc_ledger_code TEXT,
    code TEXT,
    ref_id TEXT,
    tax_id TEXT,
    ref_code TEXT,
    hsncode TEXT,
    is_default TEXT,
    acc_main_id TEXT,
    type TEXT,
    openning_bal TEXT,
    opening_balance_paid TEXT,
    published TEXT,
    updatedate TEXT,
    is_for_purchase TEXT,
    is_for_sales TEXT,
    name_lan TEXT,
    balance TEXT,
    cash_type TEXT
)
    ''');
  }

  Future<void> createTableConfig(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $tableConfig (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    logo TEXT,
    is_taxincluded TEXT
)
    ''');
  }

  Future<void> createTableDevice(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $tableDevice (
    dev_id TEXT PRIMARY KEY,
    dev_name TEXT,
    bill_id TEXT,
    sales_billtype TEXT,
    payment_billtype TEXT,
    estimate_billtype TEXT,
    salereturn_billtype TEXT,
    receipt_billtype TEXT,
    dev_number TEXT,
    com_id TEXT,
    godown_id TEXT,
    branch_id TEXT,
    edit_itemrate TEXT
)''');
  }

  Future<void> createAreaTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $tableArea (
    id TEXT PRIMARY KEY,
    area TEXT,
    name_lan TEXT,
    details TEXT,
    updatedate TEXT
)
    ''');
  }

  Future<void> createPaymentTable(Database db) async {
    await createTable(db, tablePayments, {
      'id': 'INTEGER PRIMARY KEY AUTOINCREMENT',
      'transaction_id': 'TEXT UNIQUE',
      'type': 'TEXT',
      'value': 'TEXT',
      'bank_name': 'TEXT',
      'sales_id': 'TEXT UNIQUE',
      'customer_id': 'TEXT',
    });
  }

  /// Callback function executed when the database is created for the first time.
  ///
  /// This function is responsible for creating all the necessary tables in the
  /// database. It calls various `create...Table` methods to define the schema
  /// for each table.
  ///
  /// ### Tables Created:
  /// - Device Details: Company Settings, Company, Point Settings, Tax, Unit, Category, Sales Items, Sales Orders, Bill Number, Account Type, Account Sub Type, Account Main, Account Ledgers, Config, Device, Area.
  /// - General Details: Items, Customers, Price List Details, Price List.
  /// - Sales Body: Sales Body, Sales Return Body.
  /// - Vouchers: Voucher.
  /// - Payments: Payments.
  /// - Return Log: Return Log.
  Future<void> _onCreate(Database db, int version) async {
    //Device Details
    await createCompanySettingsTable(db);
    await createCompanyTable(db);
    await createPointSettingsTable(db);
    await createTaxTable(db);
    await createUnitTable(db);
    await createCategoryTable(db);
    await createSaleItemTable(db);
    await createSaleOrderTable(db);
    await createBillTable(db);
    await createAccTypeTable(db);
    await createAccSubTypeTable(db);
    await createAccMainTable(db);
    await createAccLedgerTable(db);
    await createTableConfig(db);
    await createTableDevice(db);
    await createAreaTable(db);

    //General Details
    await createItemsTable(db);
    await createCustomersTable(db);
    await createPriceListDetailsTable(db);
    await createPriceListTable(db);

    //Sales Body
    await createSalesBodyTable(db);
    await createSalesReturnBodyTable(db);

    await createVoucherTable(db);

    await createPaymentTable(db);

    await createReturnLogTable(db);
  }

  //Sales Body

  Future<void> createSalesBodyTable(Database db) async {
    await db.execute('''
    CREATE TABLE $tableSalesBody (
    invoice_date TEXT,
    is_taxincluded TEXT,
    id TEXT PRIMARY KEY,
    sales_id TEXT,
    customer_id TEXT,
    cash_type TEXT,
    delivery_date TEXT,
    credit_eod TEXT,
    total TEXT,
    salesman TEXT,
    route TEXT,
    vehicle TEXT,
    area TEXT,
    ref_amount TEXT,
    tax_id TEXT,
    advance TEXT,
    other TEXT,
    freight TEXT,
    discount TEXT,
    roundoff TEXT,
    invoice TEXT,
    ref_id TEXT,
    created_date TEXT,
    narration TEXT,
    sales_order_id TEXT,
    sales_ref_type TEXT,
    created_by TEXT,
    type TEXT,
    bill_type TEXT,
    cusname TEXT,
    cusdetails TEXT,
    cusemail TEXT,
    customer_address TEXT,
    customer_phone TEXT,
    subtot TEXT,
    taxtotal TEXT,
    latitude TEXT,
    longitude TEXT,
    saletype TEXT,
    salesitems TEXT, -- JSON-encoded string
    additional_cess TEXT,
    cess TEXT,
    tax TEXT,
    login_user_id TEXT
)
    ''');
  }

  Future<void> createSalesReturnBodyTable(Database db) async {
    await db.execute('''
    CREATE TABLE $tableSalesReturnBody (
    invoice_date TEXT,
    is_taxincluded TEXT,
    id TEXT PRIMARY KEY,
    sales_id TEXT,
    customer_id TEXT,
    cash_type TEXT,
    delivery_date TEXT,
    credit_eod TEXT,
    total TEXT,
    salesman TEXT,
    route TEXT,
    vehicle TEXT,
    area TEXT,
    ref_amount TEXT,
    tax_id TEXT,
    advance TEXT,
    other TEXT,
    freight TEXT,
    discount TEXT,
    roundoff TEXT,
    invoice TEXT,
    ref_id TEXT,
    created_date TEXT,
    narration TEXT,
    sales_order_id TEXT,
    sales_ref_type TEXT,
    created_by TEXT,
    type TEXT,
    bill_type TEXT,
    cusname TEXT,
    cusdetails TEXT,
    cusemail TEXT,
    customer_address TEXT,
    customer_phone TEXT,
    subtot TEXT,
    taxtotal TEXT,
    latitude TEXT,
    longitude TEXT,
    saletype TEXT,
    salesitems TEXT,
    additional_cess TEXT,
    cess TEXT,
    tax TEXT,
    login_user_id TEXT
)
    ''');
  }

  Future<void> createVoucherTable(Database db) async {
    await db.execute('''
    CREATE TABLE $tableVouchers (
    voucher_id TEXT PRIMARY KEY,
    vid TEXT,
    amount TEXT,
    narration TEXT,
    date TEXT,
    created_by TEXT,
    type TEXT,
    bill_type TEXT,
    toid TEXT,
    login_user_id TEXT,
    latitude TEXT,
    longitude TEXT,
    aeging TEXT
    )
   
    ''');
  }

  Future<void> createReturnLogTable(Database db) async {
    await createTable(db, returnLog, {
      'id': 'INTEGER PRIMARY KEY AUTOINCREMENT',
      'sales_id': 'TEXT',
      'item_id': 'TEXT',
      'invoice': 'TEXT',
      'created_date': 'TEXT',
      'sale_quantity': 'INTEGER',
      'return_quantity': 'INTEGER',
    });
  }

  // Delete the database

  Future<void> deleteDatabaseFile() async {
    // Get the path to the database
    String dbPath = join(await getDatabasesPath(), dbName);

    // Delete the database
    await deleteDatabase(dbPath);

    // Set the database instance to null
    DBFunctions._database = null;

    if (kDebugMode) {
      print('Database deleted successfully');
    }
  }

  Future<bool> checkIfTableExists(Database db, String tableName) async {
    // Query to check if the table exists
    var result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
      [tableName],
    );

    // If result is not empty, the table exists
    return result.isNotEmpty;
  }

  Future<void> exportDB() async {
    try {
      // Request storage permission
      if (await Permission.storage.request().isDenied &&
          await Permission.manageExternalStorage.request().isDenied) {
        Utils().showToast('Storage permission denied');
        return;
      }

      // Define source and export paths
      String dbPath = join(await getDatabasesPath(), dbName);
      if (!await File(dbPath).exists()) {
        Utils().showToast('Database file does not exist.');
        return;
      }

      Directory exportDir = Directory(DBFunctions.dbPath);

      if (!await exportDir.exists()) {
        await exportDir.create(recursive: true);
      }

      String exportPath = join(exportDir.path, dbName);

      // Ask user what to do if the file exists
      CopyClass copyClass = await getUserCopyChoice(exportPath);
      if (copyClass == CopyClass.skip) {
        Utils().showToast('Export cancelled');
        return;
      }

      // Perform file copy based on user's choice
      await handleFileCopy(dbPath, exportPath, copyClass);

      Utils().showToast('Database exported successfully');
      return;
    } catch (e) {
      Utils().showToast('Error exporting database: Trying again...');
    }

    try {
      // Request storage permission
      if (await Permission.storage.request().isDenied &&
          await Permission.manageExternalStorage.request().isDenied) {
        Utils().showToast('Storage permission denied');
        return;
      }

      // Define source and export paths
      String dbPath = join(await getDatabasesPath(), dbName);
      if (!await File(dbPath).exists()) {
        Utils().showToast('Database file does not exist.');
        return;
      }

      Directory? exportDir = await getExternalStorageDirectory();
      if (exportDir == null) {
        Utils().showToast('Export directory not found.');
        return;
      }

      String exportPath = join(exportDir.path, dbName);

      // Ask user what to do if the file exists
      CopyClass copyClass = await getUserCopyChoice(exportPath);
      if (copyClass == CopyClass.skip) {
        Utils().showToast('Export cancelled');
        return;
      }

      // Perform file copy based on user's choice
      await handleFileCopy(dbPath, exportPath, copyClass);

      Utils().showToast('Database exported successfully');
      return;
    } catch (e) {
      Utils().showToast('Error exporting database: Failed to export database');
    }
  }

  /// Ask user whether to overwrite, create a new file, or skip
  Future<CopyClass> getUserCopyChoice(String filePath) async {
    if (!await File(filePath).exists()) return CopyClass.replace;

    return await showDialog<CopyClass>(
          context: Get.context!,
          builder: (context) {
            return AlertDialog(
              title: Text('File already exists'),
              content: Text('Do you want to overwrite or create a new file?'),
              actions: [
                TextButton(
                    onPressed: () => Get.back(result: CopyClass.replace),
                    child: Text('Overwrite')),
                TextButton(
                    onPressed: () => Get.back(result: CopyClass.newFile),
                    child: Text('New File')),
                TextButton(
                    onPressed: () => Get.back(result: CopyClass.skip),
                    child: Text('Cancel')),
              ],
            );
          },
        ) ??
        CopyClass.skip;
  }

  /// Handle file copying logic based on user selection
  Future<void> handleFileCopy(
      String srcPath, String destPath, CopyClass copyClass) async {
    switch (copyClass) {
      case CopyClass.replace:
        await File(srcPath).copy(destPath);
        break;
      case CopyClass.newFile:
        String fileName = basename(srcPath);
        String newName = await getLatestName(dirname(destPath), fileName);
        await File(srcPath).copy(join(dirname(destPath), newName));
        break;
      case CopyClass.skip:
        return;
    }
  }

  /// Get a unique filename if a file already exists
  Future<String> getLatestName(String path, String fileName) async {
    String name = fileName.replaceAll('.db', '');
    int count = 1;

    while (await File(join(path, '${name}_$count.db')).exists()) {
      count++;
    }

    return '${name}_$count.db';
  }

  Future<List<FileSystemEntity>> getFilesInDirectory(String path) async {
    final directory = Directory(path);
    if (await directory.exists()) {
      return directory.listSync(); // List files and folders
    }
    return [];
  }

  Future<void> importDB() async {
    try {
      if (await Permission.storage.request().isDenied &&
          await Permission.manageExternalStorage.request().isDenied) {
        Utils().showToast('Storage permission denied');
        return;
      }
      List<FileSystemEntity> dbItems = await getFilesInDirectory(dbPath);
      final anotherPath = await getExternalStorageDirectory();

      if (anotherPath != null) {
        final anotherDbItems = await getFilesInDirectory(anotherPath.path);
        dbItems.addAll(anotherDbItems);
      }

      dbItems = dbItems
          .where(
            (element) => element.path.endsWith('.db'),
          )
          .toList();

      if (dbItems.isNotEmpty) {
        showDialog(
            context: Get.context!,
            builder: (context) {
              return AlertDialog(
                title: const Text('Import Database'),
                content: SizedBox(
                  height: SizeConstant.percentToHeight(40),
                  width: SizeConstant.screenWidth,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final item = dbItems[index];
                      return ListTile(
                        title: Text(item.path.split('/').last),
                        onTap: () async => await handleImport(item.path),
                      );
                    },
                    itemCount: dbItems.length,
                  ),
                ),
              );
            });
      }
    } catch (e) {
      Utils().cancelToast();
      Utils().showToast('Failed to import database');
    }
  }

  Future<void> handleImport(String filePath) async {
    Get.back();
    bool success = await showDialog<bool>(
            context: Get.context!,
            builder: (context) {
              return AlertDialog(
                title: Text('Are you sure?'),
                content: Text(
                    'This action will clear all your current unsaved data. including reports!'),
                actions: [
                  TextButton(
                      onPressed: () async {
                        final dbPath = await getDatabasesPath();
                        final dbFile = File(join(dbPath, dbName));
                        await File(filePath).copy(dbFile.path);
                        Get.back(result: true);
                      },
                      child: Text('Confirm')),
                  TextButton(
                      onPressed: () {
                        Get.back(result: false);
                      },
                      child: Text('Cancel')),
                ],
              );
            }) ??
        false;

    if (success) {
      Utils().showToast('Database imported successfully');
    }
  }

  ///The following function is to extract content of a db fild in asset
  Future<Database> copyAndOpenDatabase() async {
    final documentsDirectory = await getDatabasesPath();
    final path = join(documentsDirectory, "db_copy.db");
    ByteData data = await rootBundle.load("assets/db_copy.db");
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes);

    return await openDatabase(path);
  }

  Future<Map<String, List<Map<String, dynamic>>>> getDatabaseContents(
      Database db) async {
    // Get all table names
    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%';",
    );

    Map<String, List<Map<String, dynamic>>> allData = {};
    for (var table in tables) {
      String tableName = table['name'] as String;
      List<Map<String, dynamic>> tableData = await db.query(tableName);
      allData[tableName] = tableData;
      log({tableName: tableData}.toString());
    }
    return allData;
  }
}
