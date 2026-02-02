import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kgl_express/features/map/models/osm_models.dart';


class KigaliMapPainter extends CustomPainter {
  final List<OSMWay> ways;
  final double zoom;
  final Offset offset;
  final Color? overrideColor;

  KigaliMapPainter({required this.ways, required this.zoom, required this.offset,this.overrideColor});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Use overrideColor if provided, otherwise default to a safe grey
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (var way in ways) {
      if (way.nodes.isEmpty) continue;

      // 2. Logic: Priority to overrideColor, then way.color, then fallback
      paint.color = overrideColor ?? way.color;

      // Highway check for line weight
      paint.strokeWidth = way.tags.containsKey('highway') ? 1.5 : 0.8;

      final path = Path();
      bool first = true;

      for (var node in way.nodes) {
        final pos = _latLonToPixels(node.lat, node.lon, size);

        if (first) {
          path.moveTo(pos.dx, pos.dy);
          first = false;
        } else {
          path.lineTo(pos.dx, pos.dy);
        }
      }

      if (way.tags.containsKey('building')) {
        paint.style = PaintingStyle.fill;
        // Optional: Make buildings slightly more transparent than roads
        paint.color = paint.color.withValues(alpha: 0.3);
        path.close();
      } else {
        paint.style = PaintingStyle.stroke;
      }

      canvas.drawPath(path, paint);
    }
  }

  /// Mercator Projection logic to map Kigali to your screen
  Offset _latLonToPixels(double lat, double lon, Size size) {
    // This projection is fine, but usually, we center on Kigali's specific coords
    // Lat: -1.9441, Lon: 30.0619
    double x = (lon + 180) * (size.width / 360);
    double latRad = lat * pi / 180;
    double mercN = log(tan((pi / 4) + (latRad / 2)));
    double y = (size.height / 2) - (size.width * mercN / (2 * pi));

    return Offset((x * zoom) + offset.dx, (y * zoom) + offset.dy);
  }

  @override
  bool shouldRepaint(covariant KigaliMapPainter oldDelegate) =>
      oldDelegate.zoom != zoom ||
          oldDelegate.offset != offset ||
          oldDelegate.ways != ways ||
          oldDelegate.overrideColor != overrideColor;
}
