import 'package:flutter/material.dart';
import '../../models/osm_models.dart';

class KigaliMapPainter extends CustomPainter {
  final List<OSMWay> ways;
  final double zoom;
  final Offset offset;

  KigaliMapPainter({
    required this.ways,
    required this.zoom,
    required this.offset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Background color (Kigali soil/base)
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = const Color(0xFFF1F1F1));

    for (var way in ways) {
      if (way.nodes.isEmpty) continue;

      final paint = Paint()
        ..color = way.color
        ..style = way.tags.containsKey('building')
            ? PaintingStyle.fill
            : PaintingStyle.stroke
        ..strokeWidth = _getStrokeWidth(way.tags);

      final path = Path();

      // Starting point
      Offset start = _project(way.nodes.first, size);
      path.moveTo(start.dx, start.dy);

      // Connect nodes
      for (int i = 1; i < way.nodes.length; i++) {
        Offset next = _project(way.nodes[i], size);
        path.lineTo(next.dx, next.dy);
      }

      if (way.tags.containsKey('building')) {
        path.close(); // Close building polygons
      }

      canvas.drawPath(path, paint);
    }
  }

  // Simple projection logic (to be replaced by Mercator Math later)
  Offset _project(OSMNode node, Size size) {
    return Offset(
      (node.lon * zoom) + offset.dx,
      (node.lat * zoom) + offset.dy,
    );
  }

  double _getStrokeWidth(Map<String, String> tags) {
    if (tags['highway'] == 'motorway') return 4.0 * zoom;
    return 1.5 * zoom;
  }

  @override
  bool shouldRepaint(KigaliMapPainter oldDelegate) =>
      oldDelegate.zoom != zoom || oldDelegate.offset != offset;
}