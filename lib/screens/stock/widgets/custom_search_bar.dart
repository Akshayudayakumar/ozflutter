import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String value)? onFieldSubmitted;
  final Function(String value)? onChanged;
  final int? maxLines;
  final int? minLines;
  final String? hintText;
  const CustomSearchBar({super.key, required this.controller, this.maxLines, this.minLines, this.hintText, this.onFieldSubmitted, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: TextFormField(
        controller: controller,
        minLines: minLines,
        maxLines: maxLines,
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: hintText ?? 'Search',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
