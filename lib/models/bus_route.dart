import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BusRoute {
  final String mainRouteName; // e.g., "Kigali - Huye"
  final List<String> stops;   // ["Kigali", "Ruhango", "Nyanza", "Huye"]
  final Map<String, double> priceMatrix; // "Kigali-Ruhango": 2000, etc.

  BusRoute({
    required this.mainRouteName,
    required this.stops,
    required this.priceMatrix,
  });
}

class BusSchedule {
  final String time;
  final String? lastSeenLocation;
  final DateTime? lastUpdated;
  final bool isDelayed;

  BusSchedule({
    required this.time,
    this.lastSeenLocation,
    this.lastUpdated,
    this.isDelayed = false
  });
}

