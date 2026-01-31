import 'package:flutter/material.dart';
import 'package:kgl_express/core/enums/payment_method.dart';
import 'package:kgl_express/core/utils/currency_formatter.dart';
import 'package:marquee/marquee.dart';
import 'package:kgl_express/core/enums/order_status.dart';
import 'package:kgl_express/models/order_model.dart';

class PackageCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;

  const PackageCard({super.key, required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Softer corners
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              _buildStatusLeading(),
              const SizedBox(width: 16),
              _buildOrderDetails(),
              const SizedBox(width: 12),
              _buildPriceTrailing(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusLeading() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: order.status.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14), // Squircle look
      ),
      child: Icon(
        order.status.icon,
        color: order.status.color,
        size: 26,
      ),
    );
  }

  Widget _buildOrderDetails() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Animating Title
          SizedBox(
            height: 20,
            child: order.title.length > 20
                ? Marquee(
              text: order.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              blankSpace: 20,
              velocity: 30,
              pauseAfterRound: const Duration(seconds: 2),
            )
                : Text(order.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
          const SizedBox(height: 4),
          // Animating Address
          SizedBox(
            height: 18,
            child: order.destination.length > 25
                ? Marquee(
              text: "To: ${order.destination}",
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
              blankSpace: 30,
              velocity: 25,
              pauseAfterRound: const Duration(seconds: 3),
            )
                : Text("To: ${order.destination}", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          ),
          const SizedBox(height: 8),
          _buildStatusBadge(),
        ],
      ),
    );
  }

  Widget _buildPriceTrailing() {
    final method = order.paymentMethod;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              // Integrated Payment Display
              _buildPaymentDisplay(method),
              const SizedBox(height: 6),
              // Formatted Amount
              Text(
                CurrencyUtils.formatAmount(order.price),
                style: const TextStyle(
                  fontSize: 18, // Slightly larger for readability
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
              const Text(
                "RWF",
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentDisplay(PaymentMethod method) {
    if (method.assetPath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.asset(
          method.assetPath!,
          width: 20,
          height: 20,
          fit: BoxFit.cover,
          // Fallback to icon if image fails to load
          errorBuilder: (context, error, stackTrace) =>
              Icon(method.icon, size: 20, color: Colors.blueGrey),
        ),
      );
    }
    return Icon(method.icon, size: 20, color: Colors.blueGrey);
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: order.status.color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        order.status.label.toUpperCase(),
        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900),
      ),
    );
  }
}