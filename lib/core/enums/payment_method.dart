import 'package:flutter/material.dart';

enum PaymentMethod {
  momo(
    label: 'MTN MoMo',
    assetPath: 'assets/icons/momo.jpg',
    icon: Icons.account_balance_wallet,
    isSecure: true,
  ),
  airtel(
    label: 'Airtel Money',
    assetPath: 'assets/icons/airtel_logo.png',
    icon: Icons.phone_android,
    isSecure: true,
  ),
  bkPay(
    label: 'BK Pay',
    assetPath: 'assets/icons/bk_logo.png', // You'll need this asset
    icon: Icons.account_balance,
    isSecure: true,
  ),
  spenn(
    label: 'SPENN',
    assetPath: 'assets/icons/spenn_logo.png', // You'll need this asset
    icon: Icons.qr_code_scanner,
    isSecure: true,
  ),
  card(
    label: 'Card (Visa/Mastercard)',
    assetPath: null,
    icon: Icons.credit_card,
    isSecure: true,
  ),
  cash(
    label: 'Cash',
    assetPath: null,
    icon: Icons.payments_outlined,
    isSecure: false, // User-to-User (Not protected by App)
  );

  final String label;
  final String? assetPath;
  final IconData icon;
  final bool isSecure;

  const PaymentMethod({
    required this.label,
    this.assetPath,
    required this.icon,
    required this.isSecure,
  });
}