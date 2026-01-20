import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:skribby/models/touch_points.dart';

class MyCustomPainter extends CustomPainter {
  MyCustomPainter({required this.pointslist});
  List<TouchPoints?> pointslist;
  List<Offset> offsetPoints = [];

  @override
  void paint(Canvas canvas, Size size) {
    Paint background = Paint()..color = Colors.white;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);
    canvas.clipRect(rect);

    //if there is a point, display the point
    //if there is line, we need to connect the points

    for(int i = 0; i < pointslist.length - 1; i++) {
      if(pointslist[i] != null && pointslist[i+1] != null) {
        //line
        canvas.drawLine(pointslist[i]!.points, pointslist[i+1]!.points, pointslist[i]!.paint);
      } else if(pointslist[i] != null && pointslist[i+1] == null) {
        //single point
        offsetPoints.clear();
        offsetPoints.add(pointslist[i]!.points);
        offsetPoints.add(Offset(pointslist[i]!.points.dx + 0.1, pointslist[i]!.points.dy + 0.1));

        canvas.drawPoints(ui.PointMode.points, offsetPoints, pointslist[i]!.paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
