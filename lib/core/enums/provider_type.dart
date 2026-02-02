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


enum Speciality{
  mechanic(
    label:"Mechanic",
    icon:Icons.settings,
  ),
  electrician(
    label:"Electrician",
    icon:Icons.bolt,
  ),
  plumber(
    label:"Plumber",
    icon:Icons.plumbing,
  ),
  houseCleaning(
    label:"House Cleaning",
    icon:Icons.cleaning_services,
  ),
  carpenter(
    label:"Carpenter",
    icon:Icons.handyman,
  ),
  painter(
    label:"Painter",
    icon:Icons.format_paint,
  ),
  masonry(
    label:"Masonry & construction",
    icon:Icons.foundation,
  ),
  welder(
    label:"Professional Welder",
    icon:Icons.precision_manufacturing,
  ),
  tiler(
    label:"Tiling & Flooring",
    icon:Icons.grid_view,
  ),
  acRepair(
    label:"AC Repair",
    icon:Icons.ac_unit,
  ),
  laundry(
    label:"Laundry",
    icon:Icons.local_laundry_service,
  ),
  landscaper(
    label:"Landscaping",
    icon:Icons.landscape,
  );

  final String label;
  final IconData icon;

  const Speciality({
    required this.label,
    required this.icon,
  });
}