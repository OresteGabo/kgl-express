import 'package:flutter/material.dart';
import 'package:kgl_express/models/order_model.dart';

class PaymentSummary extends StatelessWidget {
  final OrderModel order;

  const PaymentSummary({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final method = order.paymentMethod;

    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: method.assetPath != null
              ? Image.asset(method.assetPath!, fit: BoxFit.contain)
              : Icon(method.icon, color: Colors.blueGrey, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Payment Method", style: TextStyle(color: Colors.grey, fontSize: 11)),
            Text(method.label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const Spacer(),
        Text(
          "${order.price.toInt()} RWF",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}