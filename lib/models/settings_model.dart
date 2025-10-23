class SettingsModel {
  bool? multipleRate;
  bool? taxView;
  bool? cesView;
  bool? returnMode;
  bool? balanceView;
  bool? addressView;
  bool? currentStockView;
  bool? sendSMS;
  bool? syncOnSave;
  bool? redeem;
  bool? itemRepeat;
  bool? billDiscount;
  bool? collectionAmount;
  bool? printPreview;
  bool? printMRP;
  bool? printHSN;
  String? selectedSim;
  String? cashType;
  String? thermalPaper;
  String? billFormat;
  String? editDialog;
  String? pdfSize;
  String? currency;
  String? defaultQty;
  String? incrementQty;

  SettingsModel({
    this.multipleRate,
    this.taxView,
    this.cesView,
    this.returnMode,
    this.balanceView,
    this.addressView,
    this.currentStockView,
    this.sendSMS,
    this.syncOnSave,
    this.redeem,
    this.itemRepeat,
    this.billDiscount,
    this.collectionAmount,
    this.printPreview,
    this.printMRP,
    this.printHSN,
    this.selectedSim,
    this.cashType,
    this.thermalPaper,
    this.billFormat,
    this.editDialog,
    this.pdfSize,
    this.currency,
    this.defaultQty,
    this.incrementQty,
  });

  SettingsModel.fromJson(Map<String, dynamic> json) {
    multipleRate = json['multiple_rate'];
    taxView = json['tax_view'];
    cesView = json['ces_view'];
    returnMode = json['return_mode'];
    balanceView = json['balance_view'];
    addressView = json['address_view'];
    currentStockView = json['current_stock_view'];
    sendSMS = json['send_sms'];
    syncOnSave = json['sync_on_save'];
    redeem = json['redeem'];
    itemRepeat = json['item_repeat'];
    billDiscount = json['bill_discount'];
    collectionAmount = json['collection_amount'];
    printPreview = json['print_preview'];
    printMRP = json['print_mrp'];
    printHSN = json['print_hsn'];
    selectedSim = json['selected_sim'];
    cashType = json['cash_type'];
    thermalPaper = json['thermal_paper'];
    billFormat = json['bill_format'];
    editDialog = json['edit_dialog'];
    pdfSize = json['pdf_size'];
    currency = json['currency'];
    defaultQty = json['default_qty'];
    incrementQty = json['increment_qty'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['multiple_rate'] = multipleRate;
    data['tax_view'] = taxView;
    data['ces_view'] = cesView;
    data['return_mode'] = returnMode;
    data['balance_view'] = balanceView;
    data['address_view'] = addressView;
    data['current_stock_view'] = currentStockView;
    data['send_sms'] = sendSMS;
    data['sync_on_save'] = syncOnSave;
    data['redeem'] = redeem;
    data['item_repeat'] = itemRepeat;
    data['bill_discount'] = billDiscount;
    data['collection_amount'] = collectionAmount;
    data['print_preview'] = printPreview;
    data['print_mrp'] = printMRP;
    data['print_hsn'] = printHSN;
    data['selected_sim'] = selectedSim;
    data['cash_type'] = cashType;
    data['thermal_paper'] = thermalPaper;
    data['bill_format'] = billFormat;
    data['edit_dialog'] = editDialog;
    data['pdf_size'] = pdfSize;
    data['currency'] = currency;
    data['default_qty'] = defaultQty;
    data['increment_qty'] = incrementQty;
    return data;
  }

  SettingsModel copyWith({
    bool? multipleRate,
    bool? taxView,
    bool? cesView,
    bool? returnMode,
    bool? balanceView,
    bool? addressView,
    bool? currentStockView,
    bool? sendSMS,
    bool? syncOnSave,
    bool? redeem,
    bool? itemRepeat,
    bool? billDiscount,
    bool? collectionAmount,
    bool? printPreview,
    bool? printMRP,
    bool? printHSN,
    String? selectedSim,
    String? cashType,
    String? thermalPaper,
    String? billFormat,
    String? editDialog,
    String? pdfSize,
    String? currency,
    String? defaultQty,
    String? incrementQty,
  }) {
    return SettingsModel(
      multipleRate: multipleRate ?? this.multipleRate,
      taxView: taxView ?? this.taxView,
      cesView: cesView ?? this.cesView,
      returnMode: returnMode ?? this.returnMode,
      balanceView: balanceView ?? this.balanceView,
      addressView: addressView ?? this.addressView,
      currentStockView: currentStockView ?? this.currentStockView,
      sendSMS: sendSMS ?? this.sendSMS,
      syncOnSave: syncOnSave ?? this.syncOnSave,
      redeem: redeem ?? this.redeem,
      itemRepeat: itemRepeat ?? this.itemRepeat,
      billDiscount: billDiscount ?? this.billDiscount,
      collectionAmount: collectionAmount ?? this.collectionAmount,
      printPreview: printPreview ?? this.printPreview,
      printMRP: printMRP ?? this.printMRP,
      printHSN: printHSN ?? this.printHSN,
      selectedSim: selectedSim ?? this.selectedSim,
      cashType: cashType ?? this.cashType,
      thermalPaper: thermalPaper ?? this.thermalPaper,
      billFormat: billFormat ?? this.billFormat,
      editDialog: editDialog ?? this.editDialog,
      pdfSize: pdfSize ?? this.pdfSize,
      currency: currency ?? this.currency,
      defaultQty: defaultQty ?? this.defaultQty,
      incrementQty: incrementQty ?? this.incrementQty,
    );
  }
}
