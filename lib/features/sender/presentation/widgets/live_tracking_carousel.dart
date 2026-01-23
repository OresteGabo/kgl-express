import 'package:flutter/material.dart';
import 'package:kgl_express/features/sender/presentation/widgets/live_tracking_card.dart';
import 'package:kgl_express/models/order_model.dart';

class LiveTrackingCarousel extends StatelessWidget {
  final List<OrderModel> activeOrders;
  const LiveTrackingCarousel({super.key, required this.activeOrders});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        const SizedBox(height: 12),
        SizedBox(
          height: 145,
          child: PageView.builder(
            itemCount: activeOrders.length,
            controller: PageController(viewportFraction: 0.95),
            padEnds: false,
            itemBuilder: (context, index) => LiveTrackingCard(order: activeOrders[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Live Tracking", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
        if (activeOrders.length > 1)
          Text("${activeOrders.length} Active", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
      ],
    );
  }
}