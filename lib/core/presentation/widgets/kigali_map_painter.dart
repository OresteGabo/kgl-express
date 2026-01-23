import 'package:flutter/material.dart';
import 'dart:math' as math;

class KigaliMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // ================= PAINTS =================

    final Paint secondaryStreetPaint = Paint()
      ..color = Colors.grey.withValues(alpha:0.15)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final Paint primaryRoadPaint = Paint()
      ..color = Colors.grey.withValues(alpha:0.3)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final Paint parkPaint = Paint()
      ..color = Colors.green.withValues(alpha:0.08)
      ..style = PaintingStyle.fill;

    final Paint waterPaint = Paint()
      ..color = Colors.blue.withValues(alpha:0.06)
      ..style = PaintingStyle.fill;

    final Paint hillPaint = Paint()
      ..color = Colors.grey.withValues(alpha:0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final Paint densityPaint = Paint()
      ..color = Colors.black.withValues(alpha:0.02)
      ..strokeWidth = 1;

    // ================= NEW: URBAN BRANDING =================
    // We draw this first so it sits "underneath" the streets
    _drawUrbanBranding(canvas, size);


    // ================= TOPOGRAPHY (HILLS) =================

    canvas.drawArc(
      Rect.fromLTWH(-80, 80, 260, 120),
      0,
      math.pi,
      false,
      hillPaint,
    );

    canvas.drawArc(
      Rect.fromLTWH(size.width - 200, 300, 360, 180),
      0,
      math.pi,
      false,
      hillPaint,
    );

    // ================= GREEN ZONES =================

    Path nyarutarama = Path()
      ..addOval(Rect.fromLTWH(size.width * 0.6, 40, 140, 200));
    canvas.drawPath(nyarutarama, parkPaint);
    _drawText(
      canvas,
      "NYARUTARAMA",
      Offset(size.width * 0.63, 140),
      Colors.green.withValues(alpha:0.35),
    );

    // ================= WATER / WETLAND =================

    Path wetland = Path()
      ..moveTo(size.width * 0.78, size.height * 0.6)
      ..quadraticBezierTo(
        size.width * 0.9,
        size.height * 0.65,
        size.width * 0.86,
        size.height * 0.82,
      )
      ..quadraticBezierTo(
        size.width * 0.72,
        size.height * 0.76,
        size.width * 0.78,
        size.height * 0.6,
      )
      ..close();

    canvas.drawPath(wetland, waterPaint);

    // ================= SECONDARY ROADS =================

    Path miniRoads = Path();
    for (int i = 0; i < 12; i++) {
      double y = 90.0 + (i * 55);
      miniRoads.moveTo(0, y);
      miniRoads.lineTo(size.width, y + 25);

      miniRoads.moveTo(i * 50.0, 0);
      miniRoads.lineTo((i * 50.0) - 40, size.height);
    }
    canvas.drawPath(miniRoads, secondaryStreetPaint);

    // ================= MAJOR ROADS =================

    Path mainArtery1 = Path()
      ..moveTo(0, size.height * 0.42)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.48,
        size.width,
        size.height * 0.22,
      );

    Path mainArtery2 = Path()
      ..moveTo(size.width * 0.2, size.height)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.55,
        size.width * 0.6,
        0,
      );

    canvas.drawPath(mainArtery1, primaryRoadPaint);
    canvas.drawPath(mainArtery2, primaryRoadPaint);

    _drawText(
      canvas,
      "KG 7 AVE",
      Offset(size.width * 0.48, size.height * 0.38),
      Colors.grey.withValues(alpha:0.4),
    );

    _drawText(
      canvas,
      "RN3",
      Offset(size.width * 0.78, size.height * 0.23),
      Colors.grey.withValues(alpha:0.4),
    );

    // ================= URBAN DENSITY NOISE =================

    for (int i = 0; i < 40; i++) {
      double x = (i * 30) % size.width;
      canvas.drawLine(
        Offset(x, size.height * 0.3),
        Offset(x + 25, size.height * 0.7),
        densityPaint,
      );
    }

    // ================= LANDMARKS =================
    _drawBuilding(canvas, Offset(size.width * 0.1, 90), "KACYIRU", 42);

    _drawDreamBuilding(canvas, Offset(size.width * 0.45, size.height * 0.15));

    Offset domePos = Offset(size.width * 0.75, size.height * 0.32);
    canvas.drawCircle(
      domePos,
      36,
      Paint()..color = Colors.blue.withValues(alpha:0.05),
    );
    canvas.drawCircle(
      domePos,
      36,
      Paint()
        ..color = Colors.blue.withValues(alpha:0.25)
        ..style = PaintingStyle.stroke,
    );
    _drawText(
      canvas,
      "CONVENTION CTR",
      domePos.translate(-34, 42),
      Colors.blueGrey,
      isBold: true,
    );

    // ================= DISTRICT LABELS =================

    _drawText(canvas, "KIMIHURURA", Offset(size.width * 0.4, size.height * 0.48), Colors.black26);
    _drawText(canvas, "GISOZI", Offset(size.width * 0.2, size.height * 0.25), Colors.black12);
    _drawText(canvas, "REMERA", Offset(size.width * 0.65, size.height * 0.55), Colors.black12);
    _drawText(canvas, "NYAMIRAMBO", Offset(size.width * 0.15, size.height * 0.68), Colors.black12);
    _drawText(canvas, "KANOMBE", Offset(size.width * 0.78, size.height * 0.78), Colors.black12);

    // ================= POI DOTS =================

    _drawPoi(canvas, Offset(size.width * 0.42, size.height * 0.52));
    _drawPoi(canvas, Offset(size.width * 0.38, size.height * 0.50));
    _drawPoi(canvas, Offset(size.width * 0.44, size.height * 0.48));
    _drawPoi(canvas, Offset(size.width * 0.47, size.height * 0.51));

    // ================= ACTIVE ROUTE =================

    final Paint activeRoute = Paint()
      ..color = Colors.green
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Path nav = Path()
      ..moveTo(50, size.height * 0.82)
      ..lineTo(120, size.height * 0.75)
      ..lineTo(150, size.height * 0.52);

    canvas.drawPath(nav, activeRoute);
    _drawPin(canvas, Offset(150, size.height * 0.52));

    // ================= COMPASS =================

    _drawText(
      canvas,
      "N",
      Offset(size.width - 22, 18),
      Colors.black26,
      isBold: true,
    );
  }

  // ================= HELPERS =================

  void _drawBuilding(Canvas canvas, Offset pos, String label, double size) {
    canvas.drawRect(
      Rect.fromLTWH(pos.dx, pos.dy, size, size),
      Paint()..color = Colors.black.withValues(alpha:0.03),
    );
    _drawText(canvas, label, pos.translate(0, -15), Colors.black12);
  }

  void _drawPin(Canvas canvas, Offset pos) {
    canvas.drawCircle(pos, 6, Paint()..color = Colors.red);
    canvas.drawCircle(pos, 12, Paint()..color = Colors.red.withValues(alpha:0.2));
  }

  void _drawPoi(Canvas canvas, Offset pos) {
    canvas.drawCircle(pos, 2.5, Paint()..color = Colors.orange.withValues(alpha:0.4));
  }

  // À ajouter dans votre KigaliMapPainter
  void _drawUrbanBranding(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: "KGL EXPRESS",
        style: TextStyle(
          color: Colors.grey.withValues(alpha: 0.05), // Très subtil
          fontSize: 40,
          fontWeight: FontWeight.w900,
          letterSpacing: 10,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    // On le place en diagonale dans un coin vide
    canvas.save();
    canvas.translate(size.width * 0.1, size.height * 0.15);
    canvas.rotate(-math.pi / 4); // Rotation stylée
    textPainter.paint(canvas, Offset.zero);
    canvas.restore();
  }

  void _drawDreamBuilding(Canvas canvas, Offset pos) {
    final paint = Paint()
      ..color = Colors.blue.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Un bâtiment futuriste en forme de flèche (vitesse/logistique)
    Path tower = Path();
    tower.moveTo(pos.dx, pos.dy);
    tower.lineTo(pos.dx + 20, pos.dy - 60);
    tower.lineTo(pos.dx + 40, pos.dy);
    tower.close();

    // Fenêtres ou détails techniques
    canvas.drawPath(tower, paint);
    canvas.drawLine(pos.translate(10, -30), pos.translate(30, -30), paint);

    _drawText(canvas, "HQ KGL", pos.translate(0, 5), Colors.blueGrey);
  }

  void _drawText(
      Canvas canvas,
      String text,
      Offset offset,
      Color color, {
        bool isBold = false,
      }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}