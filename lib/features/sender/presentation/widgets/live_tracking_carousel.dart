import 'package:flutter/material.dart';
import 'package:kgl_express/features/sender/presentation/widgets/live_tracking_card.dart';
import 'package:kgl_express/models/order_model.dart';

class LiveTrackingCarousel extends StatelessWidget {
  final List<OrderModel> activeOrders;
  const LiveTrackingCarousel({super.key, required this.activeOrders});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(),
        const SizedBox(height: 12),

        // This replaces the PageView. It handles height automatically.
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start, // Align to top
            children: activeOrders.map((order) {
              return Container(
                // This ensures cards are wide enough on both phone and tablet
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.only(right: 12, bottom: 10),
                child: LiveTrackingCard(order: order),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Live Tracking",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.blueAccent),
        ),
        if (activeOrders.length > 1)
          Text("${activeOrders.length} ACTIVE", style: const TextStyle(color: Colors.grey, fontSize: 10)),
      ],
    );
  }
}