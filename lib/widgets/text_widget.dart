import 'package:flutter/material.dart';

import '../Constants/constant.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final bool bold;
  final Color? color;
  final int? maxLines;
  final TextAlign textAlign;
  final TextOverflow? overflow;

  const TextWidget(
    this.text, {
    super.key,
    this.style,
    this.bold = false,
    this.textAlign = TextAlign.left,
    this.maxLines = 1,
    this.color, this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: (style ?? FontConstant.inter).copyWith(
        color: color,
        fontWeight: bold ? FontWeight.bold : null,
      ),
      maxLines: maxLines,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }
}
