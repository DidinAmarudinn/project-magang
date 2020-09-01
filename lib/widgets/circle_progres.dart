import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nabung_beramal/colors/colors_schema.dart';

class CircleProgress extends CustomPainter {
  int target;
  int progress;
  CircleProgress(this.target, this.progress);
  @override
  void paint(Canvas canvas, Size size) {
    Paint outerCircle = Paint()
      ..strokeWidth = 10
      ..color = Colors.white
      ..style = PaintingStyle.stroke;

    Paint completeArc = Paint()
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..color = ColorsSchema().primaryColors;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2) - 7;
    canvas.drawCircle(center, radius, outerCircle);
    double angle = 2 * pi * (progress / target);
    canvas.drawArc(Rect.fromCircle(radius: radius, center: center), -pi / 2,
        angle, false, completeArc);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
