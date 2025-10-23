import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/register_controller.dart';

class PaymentReport extends GetView<RegisterController> {
  const PaymentReport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          if (controller.payments.isEmpty) {
            return const Center(
              child: Text('No Records Available'),
            );
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              final payment = controller.payments[index];
              return ListTile(
                title: Text(payment.transactionId ?? ''),
                subtitle: Text(payment.bankName ?? ''),
              );
            },
            itemCount: controller.payments.length,
          );
        },
      ),
    );
  }
}
