import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/screens/pdf/controller/pdf_controller.dart';
import 'package:ozone_erp/utils/utils.dart';
import 'package:printing/printing.dart';

import '../../../data/app_data.dart';
import '../../../database/tables/export_insert.dart';
import '../../../models/device_details.dart';
import '../../../models/general_details.dart';
import '../../newsale/controller/new_sale_controller.dart';

class PrintersController extends GetxController {
  List<Printer> printers = [];
  RxList<BluetoothDevice> devices = <BluetoothDevice>[].obs;

  @override
  void onInit() {
    checkBluetoothStatus();
    checkScanning();
    discoverWiFiPrinters('192.168.1');
    getInitialDetails();
    // discoverBluetoothDevices();
    super.onInit();
  }

  // void getPrinters() async {
  //   printers = await Printing.listPrinters();
  //   update();
  // }

  final salesController = Get.find<NewSaleController>();

  Rx<CompanySettings> companySettings = CompanySettings().obs;
  Rx<Company> company = Company().obs;
  Rx<Customers> customer = Customers().obs;
  RxBool isScanning = false.obs;
  List<Company> companyList = [];
  List<CompanySettings> companySettingsList = [];
  List<Items> items = [];

  getCustomer() {
    customer.value = salesController.selectedCustomer.value;
  }

  String getGrandTotal() {
    return salesController.grandTotal.value.toString();
  }

  getItems() {
    items = salesController.addedItems;
  }

  Future<void> getInitialDetails() async {
    companySettingsList = await InsertCompanySettings().getCompanySettings();
    companyList = await InsertCompany().getCompany();
    companySettings.value = companySettingsList[0];
    company.value = companyList[0];
    getCustomer();
    getItems();
    update();
  }

  Future<void> printPdf(Printer printer) async {
    final pdfData = Get.find<PdfController>().pdfData!;
    await Printing.directPrintPdf(printer: printer, onLayout: (_) => pdfData);
  }

  Future<void> checkBluetoothStatus() async {
    if (!await FlutterBluePlus.isSupported) {
      Utils().showToast("Bluetooth is not supported by this device");
      return;
    }
    var subscription = FlutterBluePlus.adapterState.listen(
      (event) {
        if (event == BluetoothAdapterState.on) {
          scanDevices();
        } else {
          Utils().showToast("Your bluetooth is off");
        }
      },
    );
    if (!kIsWeb && Platform.isAndroid) {
      await FlutterBluePlus.turnOn();
      await scanDevices();
    }
    subscription.cancel();
  }

  void checkScanning() {
    FlutterBluePlus.isScanning.listen(
      (event) {
        isScanning.value = event;
      },
    );
  }

  // Get Bluetooth devices
  Future<void> scanDevices() async {
    var subscription = FlutterBluePlus.onScanResults.listen(
      (event) {
        for (ScanResult result in event) {
          if (!devices.contains(result.device)) {
            devices.add(result.device);
          }
        }
      },
    );
    FlutterBluePlus.cancelWhenScanComplete(subscription);
    await FlutterBluePlus.adapterState
        .where((event) => event == BluetoothAdapterState.on)
        .first;
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
    await FlutterBluePlus.isScanning
        .where(
          (event) => event == false,
        )
        .first;
    update();
  }

  Future<List<String>> discoverWiFiPrinters(String subnet) async {
    List<String> printers = [];
    for (int i = 1; i < 255; i++) {
      String ip = "$subnet.$i";
      try {
        final socket = await Socket.connect(ip, 9100,
            timeout: Duration(milliseconds: 100));
        printers.add(ip);
        socket.destroy();
      } catch (_) {}
    }
    return printers;
  }

  Future<void> printEscPos(
      String type, dynamic target, List<int> commands) async {
    if (type == "WiFi") {
      final socket = await Socket.connect(target, 9100);
      socket.add(commands);
      socket.close();
    } else if (type == "Bluetooth") {}
  }

  Future<void> printViaBluetooth(BluetoothDevice device) async {
    await device.connect(autoConnect: true);
    List<BluetoothService> services = await device.discoverServices();
    const printerServiceUuid = '00001101-0000-1000-8000-00805F9B34FB';
    BluetoothService? service = services
        .firstWhere((s) => s.serviceUuid.toString() == printerServiceUuid);
    BluetoothCharacteristic? characteristic = service.characteristics.first;
    characteristic.write(await escCommand());
    await device.disconnect();
  }

  PaperSize getPaperSize() {
    switch (AppData().getSettings().thermalPaper ?? '2') {
      case '2':
        return PaperSize.mm58;
      case '2.5':
        return PaperSize.mm72;
      case '3':
        return PaperSize.mm80;
      default:
        return PaperSize.mm58;
    }
  }

  Future<List<int>> escCommand() async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(getPaperSize(), profile);
    final List<int> bytes = [];

    // Header
    bytes.addAll(generator.text(
      companySettings.value.name ?? 'Unavailable',
      styles: const PosStyles(
          align: PosAlign.center, bold: true, height: PosTextSize.size2),
    ));
    bytes.addAll(generator.text(
      companySettings.value.address ?? 'Unavailable',
      styles: const PosStyles(align: PosAlign.center),
    ));
    bytes.addAll(generator.text(r'GST No: 32FFDPS0441J1ZK',
        styles: const PosStyles(align: PosAlign.center)));
    bytes.addAll(generator.text('TAX INVOICE',
        styles: const PosStyles(align: PosAlign.center, bold: true)));
    bytes.addAll(generator.hr()); // Horizontal line

    // Invoice Details
    bytes.addAll(generator.text('To: ${customer.value.name}'));
    bytes.addAll(generator.text(
        'Address: ${customer.value.addressLine1}${customer.value.addressLine2 != null && customer.value.addressLine2!.isNotEmpty ? ' - ${customer.value.addressLine2}' : ''}'));
    bytes.addAll(generator.text(
        'Phone: ${customer.value.phone!.isNotEmpty ? customer.value.phone : customer.value.contactNumber!.isNotEmpty ? customer.value.contactNumber : 'N/A'}'));
    bytes.addAll(generator.hr()); // Horizontal line

    // Table Header
    bytes.addAll(generator.text('S.No   Item          Qty   Rate    Amount',
        styles: const PosStyles(bold: true)));
    bytes.addAll(generator.hr(ch: '-'));

    // Table Rows
    items.map(
      (item) {
        bytes.addAll(generator.text(
            '${items.indexWhere((element) => element.id == item.id) + 1}      ${item.name ?? 'Item'}       ${salesController.selectedQuantity[item.id!]}    ${item.srate}  ${double.parse(item.mrp!).round() * salesController.selectedQuantity[item.id!]!}'));
      },
    );

    // Totals Section
    bytes.addAll(generator.hr());
    bytes.addAll(generator.text('Total (Before Tax):    3,200.73',
        styles: const PosStyles(align: PosAlign.right)));
    bytes.addAll(generator.text('GST:                   896.19',
        styles: const PosStyles(align: PosAlign.right)));
    bytes.addAll(generator.text(r'Cess:                  384.08',
        styles: const PosStyles(align: PosAlign.right)));
    bytes.addAll(generator.text('Bill Total:          ${getGrandTotal()}',
        styles: const PosStyles(align: PosAlign.right, bold: true)));

    // Amount in Words
    bytes.addAll(generator.text(
        'Amount in Words: Four Thousand Four Hundred and Eighty-One Only'));

    // QR Code
    bytes.addAll(generator.qrcode(
        'upi://pay?pa=${AppData().getUpiID()}&am=${getGrandTotal()}&cu=INR'));

    // Footer
    bytes.addAll(generator.hr());
    bytes.addAll(generator.text('Authorized Signatory',
        styles: const PosStyles(align: PosAlign.right)));
    bytes.addAll(generator.cut());

    return bytes;
  }

  // Future<void> printViaBluetooth(String deviceAddress) async {
  //   final BluetoothConnection connection =
  //   await BluetoothConnection.toAddress(deviceAddress);
  //
  //   final commands = await escCommand();
  //
  //   connection.output.add(Uint8List.fromList(commands));
  //   await connection.output.allSent;
  //   connection.finish(); // Close the connection
  // }
  //
  // Future<void> discoverBluetoothDevices() async {
  //   devices = await FlutterBluetoothSerial.instance.getBondedDevices();
  //   update();
  // }

  Future<void> printViaWiFi(String ipAddress, int port) async {
    final Socket socket = await Socket.connect(ipAddress, port);

    final commands = await escCommand();
    socket.add(commands);

    socket.close(); // Close the connection after sending
  }
}
