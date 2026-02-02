import 'package:flutter/material.dart';
import 'package:kgl_express/features/sender/presentation/widgets/live_tracking_card.dart';
import 'package:kgl_express/models/order_model.dart';

class LiveTrackingCarousel extends StatelessWidget {
  final List<OrderModel> activeOrders;
  const LiveTrackingCarousel({super.key, required this.activeOrders});

  @override
  Widget build(BuildContext context) {
    if (activeOrders.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(context),
        const SizedBox(height: 12),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: activeOrders.map((order) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.9,
                // Adding a bit of padding to avoid shadow clipping
                padding: const EdgeInsets.only(right: 16, bottom: 12),
                child: LiveActivityFactory.createCard(order, context),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Live Tracking",
          style: theme.textTheme.titleSmall?.copyWith(
            // Using primary for the brand color (your Gold/Green)
            // instead of hardcoded BlueAccent
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
        if (activeOrders.length > 1)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "${activeOrders.length} ACTIVE",
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}