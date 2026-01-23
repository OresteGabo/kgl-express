import 'package:flutter/material.dart';

enum OrderStatus {
  pending(label: 'Waiting for Moto', color: Colors.orange),
  pickingUp(label: 'Moto is coming', color: Colors.blue),
  inTransit(label: 'On the way', color: Colors.indigo),
  delivered(label: 'Delivered', color: Colors.green),
  cancelled(label: 'Cancelled', color: Colors.red);

  final String label;
  final Color color;

  const OrderStatus({required this.label, required this.color});
}