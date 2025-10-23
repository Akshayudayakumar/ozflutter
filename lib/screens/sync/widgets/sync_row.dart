import 'package:flutter/material.dart';
import 'package:ozone_erp/constants/constant.dart';
import 'package:ozone_erp/utils/date_converter.dart';

class SyncRow extends StatefulWidget {
  final String title;
  final String? date;
  final VoidCallback sync;
  final bool rotating;
  final String errorMessage;

  const SyncRow({
    super.key,
    required this.title,
    required this.date,
    required this.sync,
    this.rotating = false,
    this.errorMessage = '',
  });

  @override
  State<SyncRow> createState() => _SyncRowState();
}

class _SyncRowState extends State<SyncRow> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleRotation() {
    if (widget.rotating) {
      _controller.repeat();
    } else {
      double currentRotation = _controller.value;
      double remainingRotation = 1.0 - currentRotation;

      _controller.animateTo(
        1.0,
        duration: Duration(
          milliseconds:
              (remainingRotation * _controller.duration!.inMilliseconds)
                  .round(),
        ),
        curve: Curves.linear,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    toggleRotation();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(100),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: SizeConstant.screenWidth * .045,
                  fontWeight: FontWeight.w600,
                ),
              )),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.rotating ? null : widget.sync,
                  borderRadius: BorderRadius.circular(50),
                  child: RotationTransition(
                    turns: _controller,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(AssetConstant.sync,
                          width: SizeConstant.screenWidth * .07),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(widget.date?? 'Not Sync yet',
            style: TextStyle(
              fontSize: SizeConstant.screenWidth * .035,
              color: widget.date == null ? Colors.orange.shade700 : Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
          ),
          if (widget.errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                widget.errorMessage,
                style: FontConstant.inter.copyWith(color: Colors.red.shade700, fontSize: SizeConstant.screenWidth * .035),
              ),
            ),
        ],
      ),
    );
  }
}
