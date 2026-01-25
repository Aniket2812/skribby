import 'package:flutter/material.dart';
import 'package:skribby/models/touch_points.dart';
import 'package:skribby/widgets/canvas/my_custom_painter.dart';

/// Drawing canvas widget with gesture detection
class DrawingCanvas extends StatelessWidget {
  final List<TouchPoints?> points;
  final Function(DragStartDetails) onPanStart;
  final Function(DragUpdateDetails) onPanUpdate;
  final Function(DragEndDetails) onPanEnd;

  const DrawingCanvas({
    super.key,
    required this.points,
    required this.onPanStart,
    required this.onPanUpdate,
    required this.onPanEnd,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      child: SizedBox.expand(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: RepaintBoundary(
            child: CustomPaint(
              size: Size.infinite,
              painter: MyCustomPainter(pointslist: points),
            ),
          ),
        ),
      ),
    );
  }
}
