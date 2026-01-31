import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kgl_express/features/map/models/osm_models.dart';


class KigaliMapPainter extends CustomPainter {
  final List<OSMWay> ways;
  final double zoom;
  final Offset offset;

  KigaliMapPainter({required this.ways, required this.zoom, required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.stroke;

    for (var way in ways) {
      if (way.nodes.isEmpty) continue;

      paint.color = way.color;
      paint.strokeWidth = way.tags.containsKey('highway') ? 2.0 : 1.0;

      final path = Path();
      bool first = true;

      for (var node in way.nodes) {
        // Convert Lat/Lon to Screen X/Y
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
        path.close();
      } else {
        paint.style = PaintingStyle.stroke;
      }

      canvas.drawPath(path, paint);
    }
  }

  /// Mercator Projection logic to map Kigali to your screen
  Offset _latLonToPixels(double lat, double lon, Size size) {
    // Standard Web Mercator Projection
    double x = (lon + 180) * (size.width / 360);
    double latRad = lat * pi / 180;
    double mercN = log(tan((pi / 4) + (latRad / 2)));
    double y = (size.height / 2) - (size.width * mercN / (2 * pi));

    return Offset((x * zoom) + offset.dx, (y * zoom) + offset.dy);
  }

  @override
  bool shouldRepaint(covariant KigaliMapPainter oldDelegate) =>
      oldDelegate.zoom != zoom || oldDelegate.offset != offset || oldDelegate.ways != ways;
}