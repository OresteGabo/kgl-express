import 'package:flutter/material.dart';

// lib/core/presentation/widgets/location_connector.dart
class LocationConnector extends StatelessWidget {
  const LocationConnector({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 37), // Aligns with the icon center
      child: SizedBox(
        height: 20,
        child: VerticalDivider(thickness: 1.5, color: Colors.grey[300]),
      ),
    );
  }
}