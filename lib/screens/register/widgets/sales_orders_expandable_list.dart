import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/models/device_details.dart';
import 'package:ozone_erp/screens/register/controller/register_controller.dart';

import '../../../constants/constant.dart';
import '../../../data/app_data.dart';
import '../../../models/currency.dart';
import '../../../models/general_details.dart';

class SalesOrdersExpandableList extends StatefulWidget {
  final String title;
  final SalesOrders salesBody;

  const SalesOrdersExpandableList({
    super.key,
    required this.title,
    required this.salesBody,
  });

  @override
  State<SalesOrdersExpandableList> createState() =>
      _SalesOrdersExpandableListState();
}

class _SalesOrdersExpandableListState extends State<SalesOrdersExpandableList> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: 300.ms,
        decoration: BoxDecoration(
            color: _isExpanded ? null : AppStyle.primaryColor.withAlpha(60),
            border: Border.all(color: AppStyle.primaryColor),
            borderRadius: BorderRadius.circular(12)),
        width: SizeConstant.screenWidth,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 16,
              children: [
                Expanded(
                  child: Text(widget.title,
                      style: TextStyle(
                          color: AppStyle.primaryColor, fontSize: 18)),
                ),
                // OpenItem(
                //   openChild: DetailedReportScreen(
                //     salesBody: widget.salesBody,
                //   ),
                //   closedChild: Image.asset(
                //     AssetConstant.details,
                //     height: 20,
                //     color: AppStyle.primaryColor,
                //   ),
                // ),
              ],
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _isExpanded
                  ? 70.0 * (widget.salesBody.salesItems?.length ?? 0) +
                      SizeConstant.screenHeight * .01
                  : 0,
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                  height: SizeConstant.screenHeight * .01,
                ),
                itemCount: widget.salesBody.salesItems?.length ?? 0,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, innerIndex) {
                  final items = Get.find<RegisterController>()
                      .allItems
                      .where(
                        (element) =>
                            element.id ==
                            widget.salesBody.salesItems?[innerIndex].salItmsId,
                      )
                      .toList();
                  Items? item = items.isNotEmpty ? items.first : null;
                  return ListTile(
                    title: Text(
                        "ID: ${widget.salesBody.salesItems?[innerIndex].salItmsId ?? 'Nil'}"),
                    subtitle: Text(
                      "Name: ${item?.name ?? 'Unavailable'}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                        "${Currency.getById(AppData().getSettings().currency).symbol} ${widget.salesBody.salesItems?[innerIndex].total ?? 'Nil'}"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
