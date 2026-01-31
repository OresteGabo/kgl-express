import 'package:flutter/material.dart';

enum OrderStatus {
  pending(
      label: 'Waiting for Moto',
      color: Colors.orange,
      icon: Icons.access_time_rounded
  ),
  pickingUp(
      label: 'Moto is coming',
      color: Colors.blue,
      icon: Icons.moped_rounded // Specific for Kigali motos
  ),
  inTransit(
      label: 'On the way',
      color: Colors.indigo,
      icon: Icons.local_shipping_rounded
  ),
  delivered(
      label: 'Delivered',
      color: Colors.green,
      icon: Icons.check_circle_rounded
  ),
  cancelled(
      label: 'Cancelled',
      color: Colors.red,
      icon: Icons.cancel_rounded
  );

  final String label;
  final Color color;
  final IconData icon;

  const OrderStatus({
    required this.label,
    required this.color,
    required this.icon,
  });
}