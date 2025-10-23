import 'package:flutter/material.dart';
import 'package:ozone_erp/Constants/constant.dart';
import 'package:ozone_erp/widgets/custom_text_field.dart';

class PaymentDropdown extends StatelessWidget {
  final String paymentMethod;
  final void Function(String? value) onSelected;
  final TextEditingController transactionController;
  final TextEditingController bankNameController;
  const PaymentDropdown(
      {super.key,
      required this.paymentMethod,
      required this.onSelected,
      required this.transactionController,
      required this.bankNameController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 4,
      ),
      height: SizeConstant.percentToHeight(10),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
                padding: EdgeInsets.only(
                    top: SizeConstant.percentToWidth(2),
                    bottom: SizeConstant.percentToWidth(2),
                    right: 4),
                controller: transactionController,
                hintText: getHintText(paymentMethod)[0]),
          ),
          Expanded(
            child: CustomTextField(
                padding: EdgeInsets.only(
                    left: 4,
                    top: SizeConstant.percentToWidth(2),
                    bottom: SizeConstant.percentToWidth(2),
                    right: 8),
                controller: bankNameController,
                hintText: getHintText(paymentMethod)[1]),
          ),
          DropdownMenu(
            initialSelection: 'upi',
            width: SizeConstant.percentToWidth(30),
            onSelected: onSelected,
            dropdownMenuEntries: [
              DropdownMenuEntry(
                value: 'upi',
                label: 'UPI',
              ),
              DropdownMenuEntry(
                value: 'net_banking',
                label: 'Net Banking',
              ),
              DropdownMenuEntry(
                value: 'bank_transfer',
                label: 'Bank Transfer',
              ),
              DropdownMenuEntry(
                value: 'cheque',
                label: 'Cheque',
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<String>getHintText(String type) {
    switch (type) {
      case 'upi':
        return ['Transaction ID', 'UPI ID / Phone Number'];
      case 'net_banking':
        return ['Transaction ID', 'Transaction site'];
      case 'bank_transfer':
        return ['Transaction ID', 'Bank name'];
      case 'cheque':
        return ['Cheque Number', 'Bank name'];
      default:
        return ['', ''];
    }
  }
}
