import 'package:flutter/material.dart';

enum UserRole {
  // 1. Individuals (Send and Receive)
  individual(
    label: 'Individual',
    icon: Icons.person,
    canSell: false,
    canDrive: false,
  ),

  // 2. Sellers (Need to be paid)
  seller(
    label: 'Merchant/Seller',
    icon: Icons.storefront,
    canSell: true,
    canDrive: false,
  ),

  // 3. Companies (Bulk sending)
  company(
    label: 'Company',
    icon: Icons.business,
    canSell: false,
    canDrive: false,
  ),

  // 4. Drivers (Moto, Cars, Vans)
  driver(
    label: 'Delivery Partner',
    icon: Icons.delivery_dining,
    canSell: false,
    canDrive: true,
  );

  // Metadata properties
  final String label;
  final IconData icon;
  final bool canSell;
  final bool canDrive;

  const UserRole({
    required this.label,
    required this.icon,
    required this.canSell,
    required this.canDrive,
  });

  // Example of a helper logic inside the enum
  bool get isSender => this == UserRole.individual || this == UserRole.seller || this == UserRole.company;
}