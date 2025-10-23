import 'package:flutter/material.dart';
import 'package:ozone_erp/models/menu_item.dart';

class CategoryTile extends StatelessWidget {
  final double? height;
  final double? width;
  final MenuItem category;
  final Color color;
  final VoidCallback onTap;

  const CategoryTile({
    super.key,
    this.height,
    this.width,
    required this.category,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        height: height,
        width: width,
        decoration: BoxDecoration(
            border: Border.all(color: color),
            color: color.withOpacity(.3),
            borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            SizedBox(
              height: 30,
              width: 30,
              child: Image.asset(
                category.icon,
                fit: BoxFit.contain,
                color: color,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              category.title,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
