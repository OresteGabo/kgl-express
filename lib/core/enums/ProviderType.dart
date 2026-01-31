import 'package:flutter/material.dart';

enum ProviderType {
  individual(
    label: 'Individual',
    icon: Icons.person,
    description: 'Independent professional or "Fundi"',
  ),
  company(
    label: 'Company',
    icon: Icons.business,
    description: 'Registered business with a team',
  );

  final String label;
  final IconData icon;
  final String description;

  const ProviderType({
    required this.label,
    required this.icon,
    required this.description,
  });
}