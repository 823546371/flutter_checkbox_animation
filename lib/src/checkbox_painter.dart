import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

class CheckPainter extends CustomPainter {
  final double value;
  final bool check;

  late Color _highlightColor;
  late Color _checkMarkColor;

  var checkMarkPath = parseSvgPathData(
      'M15 31.1977C23.1081 36.4884 29.5946 43 29.5946 43C29.5946 43 37.5 25.5 69 1.5');
  var outlineBoxPath = parseSvgPathData(
      'M24 0.5H40C48.5809 0.5 54.4147 2.18067 58.117 5.88299C61.8193 9.58532 63.5 15.4191 63.5 24V40C63.5 48.5809 61.8193 54.4147 58.117 58.117C54.4147 61.8193 48.5809 63.5 40 63.5H24C15.4191 63.5 9.58532 61.8193 5.88299 58.117C2.18067 54.4147 0.5 48.5809 0.5 40V24C0.5 15.4191 2.18067 9.58532 5.88299 5.88299C9.58532 2.18067 15.4191 0.5 24 0.5Z');

  CheckPainter({
    required this.value,
    required this.check,
    Color? highlightColor,
    Color? checkMarkColor,
  }) {
    _highlightColor = highlightColor ?? Colors.blue;
    _checkMarkColor = checkMarkColor ?? Colors.white;
  }

  @override
  void paint(Canvas canvas, Size size) {
    setSizePath(size);
    final Paint paint = Paint();
    paint.strokeWidth = 6;
    paint.strokeCap = StrokeCap.round;
    paint.strokeJoin = StrokeJoin.round;
    paint.strokeCap = StrokeCap.round;

    PathMetrics pathMetrics = checkMarkPath.computeMetrics();
    late Path extractPath;
    for (PathMetric pathMetric in pathMetrics) {
      extractPath = pathMetric.extractPath(
        0.0,
        pathMetric.length * value,
      );
    }

    paint.color = _highlightColor.withOpacity(check ? 1 : 0);
    paint.style = PaintingStyle.stroke;

    canvas.drawPath(extractPath, paint);

    paint.strokeWidth = check ? 0 : 4;
    paint.color = _highlightColor;
    paint.style = check ? PaintingStyle.fill : PaintingStyle.stroke;
    canvas.drawPath(outlineBoxPath, paint);

    paint.strokeWidth = 6;
    paint.style = PaintingStyle.stroke;
    paint.color = _checkMarkColor.withOpacity(check ? 1 : 0);

    canvas.clipPath(outlineBoxPath);
    canvas.drawPath(extractPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  void setSizePath(Size size) {
    final finalPath = Path()
      ..addPath(outlineBoxPath, Offset.zero)
      ..addPath(checkMarkPath, Offset.zero);
    final Rect pathBounds = finalPath.getBounds();
    final Matrix4 matrix4 = Matrix4.identity();
    double scaleSize = pathBounds.height;
    if (pathBounds.width > pathBounds.height) {
      scaleSize = pathBounds.width;
    }
    matrix4.scale(size.width / scaleSize);
    outlineBoxPath = outlineBoxPath.transform(matrix4.storage);
    checkMarkPath = checkMarkPath.transform(matrix4.storage);
  }
}
