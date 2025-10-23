import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/constants/constant.dart';
import 'package:ozone_erp/screens/pdf/controller/printers_controller.dart';

class PrintersPreview extends GetView<PrintersController> {
  const PrintersPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Printer'),
        centerTitle: true,
      ),
      body: GetBuilder<PrintersController>(
        builder: (controller) {
          return ListView(
            shrinkWrap: true,
            children: [
              const Text(
                '   Wifi Printers',
                style: TextStyle(fontSize: 24),
              ),
              if (controller.printers.isEmpty)
                Container(
                  alignment: Alignment.center,
                  child: const Text("No Printers Available"),
                ),
              ...controller.printers.map(
                (printer) {
                  return ListTile(
                    title: Text(printer.name),
                    subtitle: Text(printer.model ?? 'Model not available'),
                    trailing: Text(
                      printer.isAvailable ? 'Available' : 'Not Available',
                      style: TextStyle(
                          color: printer.isAvailable
                              ? Colors.green[900]
                              : Colors.red),
                    ),
                    onTap: () async {
                      await controller.printViaWiFi('192.168.0.1', 5050);
                    },
                  );
                },
              ),
              SizedBox(height: SizeConstant.screenHeight * .04),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '   Bluetooth Printers',
                    style: TextStyle(fontSize: 24),
                  ),
                  Obx(
                    () => controller.isScanning.value
                        ? const CircularProgressIndicator()
                        : const SizedBox(),
                  )
                ],
              ),
              if (controller.devices.isEmpty)
                Container(
                  alignment: Alignment.center,
                  child: const Text("No Printers Available"),
                ),
              Obx(
                () => ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final device = controller.devices[index];
                    return ListTile(
                      title: Text(device.advName),
                      subtitle: Text(device.prevBondState?.name ?? ''),
                      trailing: Text(
                        device.isConnected ? 'Connected' : 'Not Connected',
                        style: TextStyle(
                            color: device.isConnected
                                ? Colors.green[900]
                                : Colors.red),
                      ),
                      onTap: () async {
                        await controller.printViaBluetooth(device);
                      },
                    );
                  },
                  itemCount: controller.devices.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
