import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/new_sale_controller.dart';

class GstTypeRadio extends StatelessWidget {
  const GstTypeRadio({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewSaleController>(builder: (controller) {
      return Padding(
        padding: const EdgeInsets.all(8),
        // child: Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: [
        //     Row(
        //       children: [
        //         Radio(
        //             value: 'included',
        //             activeColor: AppStyle.radioColor,
        //             groupValue: controller.gstType,
        //             onChanged: (value) {
        //               controller.updateGstType(value!);
        //             }),
        //         const Text('GST Included')
        //       ],
        //     ),
        //     Row(
        //       children: [
        //         Radio(
        //             value: 'excluded',
        //             activeColor: AppStyle.radioColor,
        //             groupValue: controller.gstType,
        //             onChanged: (value) {
        //               controller.updateGstType(value!);
        //             }),
        //         const Text('GST Excluded')
        //       ],
        //     ),
        //   ],
        // ),
      );
    });
  }
}
