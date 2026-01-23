import 'package:flutter/material.dart';
import 'package:kgl_express/core/enums/order_status.dart';
import 'package:kgl_express/models/order_model.dart';

class TrackButton extends StatelessWidget {
  final OrderModel order;

  // Fixed Constructor: Removed BuildContext and positional 'order'
  const TrackButton({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // context is already provided here by the build method
    final bool isLive = order.status == OrderStatus.inTransit;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => Navigator.pop(context),
        icon: Icon(isLive ? Icons.map : Icons.arrow_back, color: Colors.white),
        label: Text(
          isLive ? "Open Live Map" : "Close Details",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isLive ? Colors.blueAccent : Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
      ),
    );
  }
}