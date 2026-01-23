import 'package:flutter/material.dart';

enum PaymentMethod {
  momo(
    label: 'MTN MoMo',
    assetPath: 'assets/icons/momo.jpg',
    icon: Icons.account_balance_wallet,
  ),
  airtel(
    label: 'Airtel Money',
    assetPath: 'assets/icons/airtel_logo.png',
    icon: Icons.phone_android,
  ),
  cash(
    label: 'Cash on Delivery',
    assetPath: null, // Uses Material Icon
    icon: Icons.payments_outlined,
  );

  final String label;
  final String? assetPath;
  final IconData icon;

  const PaymentMethod({
    required this.label,
    this.assetPath,
    required this.icon,
  });
}