import 'package:flutter/material.dart';
import 'package:ozone_erp/screens/dashboard/widgets/sales_painter.dart';

class SalesReportCircle extends StatefulWidget {
  final double height;
  final double width;
  final Widget child;
  final List<Color> colors;
  final List<double> values;

  const SalesReportCircle({
    super.key,
    this.height = double.infinity,
    this.width = double.infinity,
    required this.child,
    required this.colors,
    required this.values,
  });

  @override
  State<SalesReportCircle> createState() => _SalesReportCircleState();
}

class _SalesReportCircleState extends State<SalesReportCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..forward();

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: widget.height,
          width: widget.width,
          padding: EdgeInsets.all(28),
          child: CustomPaint(
            painter: SalesPainter(
              values: widget.values,
              animation: _animation,
              colors: widget.colors,
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: widget.child),
            ),
          ),
        );
      },
    );
  }
}
