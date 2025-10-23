import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/models/sales_body.dart';
import 'package:ozone_erp/routes/routes_class.dart';
import 'package:ozone_erp/widgets/open_item.dart';

import '../../../constants/constant.dart';
import '../controller/register_controller.dart';
import '../screen/export_reports.dart';

class SalesReportExpandableList extends StatefulWidget {
  final String title;
  final Widget extendedChild;
  final double expandedHeight;
  final SalesBody salesBody;
  final bool showEdit;

  const SalesReportExpandableList({
    super.key,
    required this.title,
    required this.extendedChild,
    required this.expandedHeight,
    required this.salesBody,
    this.showEdit = true,
  });

  @override
  State<SalesReportExpandableList> createState() =>
      _SalesReportExpandableListState();
}

class _SalesReportExpandableListState extends State<SalesReportExpandableList> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    bool isSynced = Get.find<RegisterController>()
            .getSyncStatusById(widget.salesBody.id!)?['status'] ==
        1;
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: 300.ms,
        decoration: BoxDecoration(
            color: _isExpanded
                ? isSynced
                    ? null
                    : Colors.red.withAlpha(60)
                : AppStyle.primaryColor.withAlpha(60),
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
                if (widget.showEdit && !isSynced)
                  GestureDetector(
                    onTap: () => Get.toNamed(RoutesName.newSale,
                        arguments: widget.salesBody.toJson()),
                    child: Image.asset(
                      AssetConstant.editText,
                      height: 20,
                      color: AppStyle.primaryColor,
                    ),
                  ),
                OpenItem(
                  openChild: DetailedReportScreen(
                    salesBody: widget.salesBody,
                  ),
                  closedChild: Image.asset(
                    AssetConstant.details,
                    height: 20,
                    color: AppStyle.primaryColor,
                  ),
                ),
              ],
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _isExpanded ? widget.expandedHeight : 0,
              padding: const EdgeInsets.all(8.0),
              child: widget.extendedChild,
            ),
            if (widget.showEdit && !isSynced)
              AnimatedContainer(
                alignment: Alignment.centerRight,
                duration: 300.ms,
                height: _isExpanded ? 20 : 0,
                child: Text(
                  'Not Synced!',
                  style: TextStyle(color: Colors.red),
                ),
              )
          ],
        ),
      ),
    );
  }
}
