import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kgl_express/core/presentation/widgets/kigali_map_painter.dart';
import 'package:kgl_express/features/sender/presentation/widgets/logistic_draggable_panel.dart';

// Simple Placeholder for your Map/Dashboard
class PlaceholderHomeScreen extends StatefulWidget {
  const PlaceholderHomeScreen({super.key});

  @override
  State<PlaceholderHomeScreen> createState() => _PlaceholderHomeScreenState();
}

class _PlaceholderHomeScreenState extends State<PlaceholderHomeScreen> {
  // Initializing with 0.35 because that is the initialChildSize of your panel
  final ValueNotifier<double> panelScroll = ValueNotifier(0.35);

  @override
  void dispose() {
    panelScroll.dispose(); // Proper memory management
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Animated Map Background
          Positioned.fill(
            child: ValueListenableBuilder<double>(
              valueListenable: panelScroll,
              builder: (_, extent, __) {
                // We use (extent - 0.35) so the effect starts ONLY when
                // the user pulls the sheet above its starting position.
                double factor = (extent - 0.35).clamp(0.0, 1.0);

                double parallaxOffset = factor * -150;
                double scale = 1.0 + (factor * 0.4);
                double blur = factor * 5;

                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.diagonal3Values(scale, scale, 1.0)
                    ..setTranslationRaw(0.0, parallaxOffset, 0.0),
                  child: ClipRect(
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                      child: CustomPaint(painter: KigaliMapPainter()),
                    ),
                  ),
                );
              },
            ),
          ),

          // 2. Top Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("KIGALI, RW",
                          style: TextStyle(color: Colors.grey[600], fontSize: 10, letterSpacing: 2)),
                      Text("Friday, 23 Jan",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                  // Votre bouton de notification Material existant...
                ],
              ),
            ),
          ),

          // 3. The Interactive Panel
          LogisticsDraggablePanel(
            scrollNotifier: panelScroll,
          ),
        ],
      ),
    );
  }
}



