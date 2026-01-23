import 'package:flutter/material.dart';

abstract class PackageItem {
  final String id;
  final String name;
  final int quantity;
  final double? weight;

  PackageItem({
    required this.id,
    required this.name,
    this.quantity = 1,
    this.weight,
  });

  IconData get icon;
  Color get categoryColor;
  bool get isHazardous;

  // Use the Enum type here
  CompatibilityGroup get compatibilityGroup;
}

class FoodPackage extends PackageItem {
  FoodPackage({required super.id, required super.name, super.quantity, super.weight});

  @override
  IconData get icon => Icons.restaurant;
  @override
  Color get categoryColor => Colors.orange;
  @override
  bool get isHazardous => false;
  @override
  CompatibilityGroup get compatibilityGroup => CompatibilityGroup.safe;
}

class ToxicPackage extends PackageItem {
  ToxicPackage({required super.id, required super.name, super.quantity, super.weight});

  @override
  IconData get icon => Icons.science;
  @override
  Color get categoryColor => Colors.redAccent;
  @override
  bool get isHazardous => true;
  @override
  CompatibilityGroup get compatibilityGroup => CompatibilityGroup.hazardous;
}

enum CompatibilityGroup {
  safe,      // Food, Clothes, etc.
  hazardous, // Chemicals, Acids
  fragile    // Glass, Electronics (if you want them separated too)
}