import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:multi_kyc_sdk/src/domain/entity/liveness/selfie_data.dart';

@internal
class CustomFacePainter extends CustomPainter {
  final SelfieData data;

  const CustomFacePainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.clipRect(rect);
    //_paintBoundingBox(rect, canvas, Colors.blue);
    //_paintBoundingBox(data.imageRect, canvas, Colors.red);
    _paintBoundingBox(data.headRect, canvas, Colors.green);
    _paintBoundingBox(data.noseRect, canvas, Colors.yellow);
  }

  void _paintBoundingBox(Rect rect, Canvas canvas, Color color) {
    final List<Offset> points = [
      rect.topLeft,
      rect.topRight,
      rect.bottomRight,
      rect.bottomLeft,
    ];

    _paintBoundingBoxStroke(points, canvas, color);
  }

  void _paintBoundingBoxStroke(List<Offset> points, Canvas canvas, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..blendMode = BlendMode.srcOver;

    final path = Path();
    final start = points.first;

    path.moveTo(start.dx, start.dy);

    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomFacePainter oldPainter) {
    return oldPainter.data != data;
  }
}
