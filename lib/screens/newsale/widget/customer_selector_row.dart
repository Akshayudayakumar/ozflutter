import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/constants/constant.dart';
import 'package:ozone_erp/screens/newsale/controller/new_sale_controller.dart';
import '../../../routes/routes_class.dart';
import '../../../widgets/shadow_box.dart';


class CustomerSelectorRow extends GetView<NewSaleController> {
  const CustomerSelectorRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final customer = controller.selectedCustomer.value;
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeConstant.screenWidth * 0.05),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: InkWell(
                onTap: () async{
                  final result = await Get.toNamed(RoutesName.selectCustomer);
                  if(result != null){
                    controller.selectedCustomer.value = result;
                  }
                  controller.isDetailsVisible.toggle();
                },
                child: ShadowBox(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  border: Border.all(color: Colors.grey, width: 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              customer.name?.toUpperCase() ?? 'Select Customer',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: (customer.name?.length ?? 0) > 15
                                  ? Get.textTheme.titleSmall?.copyWith(fontSize: 13)
                                  : Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await Get.toNamed(RoutesName.selectCustomer);
                              controller.isDetailsVisible.value = true;
                            },
                            child: const Icon(Icons.person_search_outlined, color: Colors.grey, size: 20),
                          ),
                        ],
                      ),
                      if (controller.isDetailsVisible.value) ...[
                        const SizedBox(height: 8),
                        const Divider(
                          height: 1,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetails(
                              customer.phone ?? 'No phone number',
                            ),
                            _buildDetails(
                              customer.addressLine1 ?? 'No address found',
                            ),
                            if (customer.gst?.isNotEmpty ?? false)
                              _buildDetails('GSTIN: ${customer.gst}'),
                            if (customer.leadRefId != null)
                              _buildDetails("Ledger Balance: ${customer.leadRefId}"),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: SizeConstant.screenWidth * .02,
            ),
            Expanded(
              flex: 4,
              child: ShadowBox(
                height: 42,
                border: Border.all(color: Colors.grey, width: 1),
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: GetBuilder<NewSaleController>(
                  builder: (controller) {
                    return DropdownMenu(
                      inputDecorationTheme: const InputDecorationTheme(
                        border: InputBorder.none,
                        isCollapsed: true,
                        isDense: true,
                        suffixIconConstraints: BoxConstraints.expand(width: 0.0),
                      ),
                      expandedInsets: const EdgeInsets.symmetric(horizontal: 8),
                      textAlign: TextAlign.center,
                      textStyle: Get.textTheme.bodyLarge,
                      initialSelection: controller.salesBills.isEmpty ? null : controller.salesBills.first.id,
                      dropdownMenuEntries: controller.salesBills
                          .map((e) => DropdownMenuEntry(value: e.id, label: e.type ?? 'Bill Type'))
                          .toList(),
                      onSelected: (value) => controller.updateBillType(value ?? ''),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
  Widget _buildDetails(String? name){
    if(name == null || name.isEmpty){
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(name,
        overflow: TextOverflow.ellipsis,
        style: Get.textTheme.titleSmall?.copyWith(color: Colors.grey,fontSize: 12),
      ),
    );
  }
}
