import 'package:flutter/material.dart';

class CustomerDetailsRow extends StatelessWidget {
  final String title;
  final String value;
  const CustomerDetailsRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(value,
                style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}
