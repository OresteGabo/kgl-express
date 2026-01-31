import 'package:flutter/material.dart';

/// Represents a single GPS point (Node) from OpenStreetMap.
class OSMNode {
  final String id;
  final double lat;
  final double lon;

  /// Cached screen position. We update this only when zoom or offset changes.
  /// This prevents heavy Mercator math during every paint cycle.
  Offset? screenPosition;

  OSMNode({
    required this.id,
    required this.lat,
    required this.lon,
    this.screenPosition,
  });

  /// Factory to create from SQLite map
  factory OSMNode.fromMap(Map<String, dynamic> map) {
    return OSMNode(
      id: map['id'].toString(),
      lat: map['lat'],
      lon: map['lon'],
    );
  }
}

/// Represents a Way (a collection of nodes) which could be a Road, Building, or River.
class OSMWay {
  final String id;
  final List<OSMNode> nodes;
  final Map<String, String> tags;

  OSMWay({
    required this.id,
    required this.nodes,
    required this.tags,
  });

  /// Logic to determine how to draw this way based on OSM tags.
  /// This is equivalent to your C++ 'if(tags.contains("highway"))' logic.
  Color get color {
    if (tags.containsKey('highway')) {
      // Different colors for different road types
      if (tags['highway'] == 'motorway' || tags['highway'] == 'primary') {
        return const Color(0xFFFFD1A1); // Main roads (Orange-ish)
      }
      return Colors.white; // Standard streets
    }

    if (tags.containsKey('building')) {
      return const Color(0xFFD9D0C9); // Classic OSM building color
    }

    if (tags.containsKey('natural') || tags.containsKey('landuse')) {
      return const Color(0xFFC8F2BE); // Parks and Greenery
    }

    return Colors.grey.withOpacity(0.3); // Default
  }

  /// Determines if the Way should be a 'Fill' (Building) or 'Stroke' (Road)
  bool get isArea => tags.containsKey('building') || tags.containsKey('amenity');

  /// Stroke width based on road importance
  double get strokeWidth {
    switch (tags['highway']) {
      case 'motorway': return 4.0;
      case 'primary': return 3.0;
      case 'secondary': return 2.0;
      default: return 1.0;
    }
  }
}