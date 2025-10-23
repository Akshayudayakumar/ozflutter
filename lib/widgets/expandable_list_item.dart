import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ozone_erp/constants/constant.dart';

class ExpandableListItem extends StatefulWidget {
  final String title;
  final String content;

  const ExpandableListItem(
      {super.key, required this.title, required this.content});

  @override
  _ExpandableListItemState createState() => _ExpandableListItemState();
}

class _ExpandableListItemState extends State<ExpandableListItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: AnimatedContainer(
            duration: 300.ms,
            color: _isExpanded ? Colors.white : Colors.blueAccent,
            width: SizeConstant.screenWidth,
            padding: const EdgeInsets.all(16.0),
            child: AnimatedDefaultTextStyle(
              duration: 300.ms,
              style: TextStyle(
                  color: _isExpanded ? Colors.blueAccent : Colors.white,
                  fontSize: 18),
              child: Text(
                widget.title,
              ),
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: _isExpanded ? 100 : 0,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.content,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
