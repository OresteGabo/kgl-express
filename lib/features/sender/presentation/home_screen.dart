import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:kgl_express/core/presentation/widgets/kigali_map_painter.dart';
import 'package:kgl_express/features/sender/presentation/widgets/logistic_draggable_panel.dart';

class PlaceholderHomeScreen extends StatefulWidget {
  const PlaceholderHomeScreen({super.key});

  @override
  State<PlaceholderHomeScreen> createState() => _PlaceholderHomeScreenState();
}

class _PlaceholderHomeScreenState extends State<PlaceholderHomeScreen> {
  final ValueNotifier<double> panelScroll = ValueNotifier(0.45);

  String location = "KIGALI | RW"; // fallback
  late String formattedDate;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    formattedDate = DateFormat('EEEE, dd MMM').format(now);

    _loadLocation();
  }

  Future<void> _loadLocation() async {
    try {
      final result = await getCityAndCountry();
      if (mounted) {
        setState(() {
          location = result.toUpperCase();
        });
      }
    } catch (_) {
      // keep fallback if error
    }
  }

  @override
  void dispose() {
    panelScroll.dispose();
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
              builder: (_, extent, _) {
                double factor = (extent - 0.45).clamp(0.0, 1.0);
                double parallaxOffset = factor * -150;
                double scale = 1.0 + (factor * 0.4);
                double blur = factor * 5;

                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.diagonal3Values(scale, scale, 1.0)
                    ..setTranslationRaw(0.0, parallaxOffset, 0.0),
                  child: ClipRect(
                    child: ImageFiltered(
                      imageFilter:
                      ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                      child: CustomPaint(
                        painter: KigaliMapPainter(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 2. Top Bar
          SafeArea(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        location,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 10,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  // Notification button here
                ],
              ),
            ),
          ),

          // 3. Draggable Panel
          LogisticsDraggablePanel(
            scrollNotifier: panelScroll,
          ),
        ],
      ),
    );
  }
}

Future<String> getCityAndCountry() async {
  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    throw Exception("Location permission denied");
  }

  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.low,
  );

  List<Placemark> placemarks = await placemarkFromCoordinates(
    position.latitude,
    position.longitude,
  );

  final place = placemarks.first;
  return "${place.locality ?? 'Unknown'} | ${place.isoCountryCode ?? ''}";
}
