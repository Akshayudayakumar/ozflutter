import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/constants/constant.dart';
import 'package:ozone_erp/screens/dashboard/controller/dashboard_controller.dart';

class ProductOverview extends StatelessWidget {
  const ProductOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(builder: (DashBoardController controller) {
      controller.updateLineWidth();
      final width = SizeConstant.screenWidth - SizeConstant.screenWidth*.11;
      final products = controller.products;
      final inStock = products.where((element) => int.parse(element.itemQty!) > 10,).toList();
      final lowStock = products.where((element) => int.parse(element.itemQty!) <= 10 && int.parse(element.itemQty!) > 0,).toList();
      final outOfStock = products.where((element) => int.parse(element.itemQty!) <= 0,).toList();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(products.length.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
              const Text('   Products', style: TextStyle(color: Colors.black54, fontSize: 14),),
            ],
          ),
          const SizedBox(height: 10,),
          AnimatedContainer(
            duration: const Duration(seconds: 1),
            width: controller.lineWidth,
            height: 5,
            child: FittedBox(
              fit: BoxFit.fill,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 5,
                    width: width * calculatePercentageToOne(inStock.length, products.length),
                    color: Colors.greenAccent,
                  ),
                  SizedBox(width: SizeConstant.screenWidth * .01,),
                  Container(
                    height: 5,
                    width: width * calculatePercentageToOne(lowStock.length, products.length),
                    color: Colors.deepOrangeAccent,
                  ),
                  SizedBox(width: SizeConstant.screenWidth * .01,),
                  Container(
                    height: 5,
                    width: width * calculatePercentageToOne(outOfStock.length, products.length),
                    color: Colors.redAccent,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              values(color: Colors.greenAccent, stock: inStock.length, title: 'In Stock'),
              values(color: Colors.deepOrangeAccent, stock: lowStock.length, title: 'Low Stock'),
              values(color: Colors.redAccent, stock: outOfStock.length, title: 'Out of Stock'),
            ],
          )
        ],
      );
    });
  }

  double calculatePercentageToOne(int num, int total) {
    if(num == 0 && total == 0) {
      return 0;
    }
    return (num / total);
  }

  Widget values({required Color color, required int stock, required String title}) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: color,
          radius: 5,
        ),
        const SizedBox(width: 5,),
        Text('$title: ', style: const TextStyle(color: Colors.black54),),
        Text('$stock', style: const TextStyle(fontWeight: FontWeight.bold),),
      ],
    );
  }
}
