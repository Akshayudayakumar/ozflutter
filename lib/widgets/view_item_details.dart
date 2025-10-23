import 'package:flutter/material.dart';
import 'package:ozone_erp/models/general_details.dart';

import '../Constants/constant.dart';

class ViewItemDetails extends StatelessWidget {
  final Items item;
  const ViewItemDetails({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Text(
                    item.name ?? '',
                    textAlign: TextAlign.center,
                    style: FontConstant.inter
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ),
                _DetailRow(label: 'MRP', value: item.mrp.toString()),
                const SizedBox(height: 16),
                _DetailRow(
                    label: 'Wholesale Price', value: item.whRate.toString()),
                const SizedBox(height: 16),
                _DetailRow(
                    label: 'Special Price', value: item.specialRate.toString()),
                const SizedBox(height: 16),
                _DetailRow(label: 'Sales Rate', value: item.srate.toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: FontConstant().popUpStyle.copyWith(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: FontConstant.inter.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
