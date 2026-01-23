import 'package:flutter/material.dart';
import 'package:kgl_express/models/order_model.dart';

class LiveTrackingCard extends StatelessWidget {
  final OrderModel order;

  const LiveTrackingCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          // Top Row: Locations & Moped Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _LocationInfo(location: order.pickupLocation, label: "PICKUP"),
              Column(
                children: [
                  const Icon(Icons.moped, color: Colors.white70, size: 18),
                  const SizedBox(height: 2),
                  Text(
                    order.id.toUpperCase(),
                    style: const TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              _LocationInfo(location: order.destination, label: "DESTINATION"),
            ],
          ),
          const SizedBox(height: 25),

          // Bottom Row: Animated Progress Line
          const _AnimatedProgressLine(),
        ],
      ),
    );
  }
}

/// Private helper for the Location Text blocks
class _LocationInfo extends StatelessWidget {
  final String location;
  final String label;

  const _LocationInfo({required this.location, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha:0.4),
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          location,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// Private helper for the Pulse Animation
class _AnimatedProgressLine extends StatelessWidget {
  const _AnimatedProgressLine();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        // Background Dashed Line
        Row(
          children: List.generate(
            18,
                (index) => Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                height: 1.5,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha:0.15),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ),
        // Traveling Pulse Dot
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(seconds: 4),
          curve: Curves.easeInOut,
          builder: (context, value, child) {
            return LayoutBuilder(
              builder: (context, constraints) {
                // value * constraints.maxWidth allows the dot to move relative to screen width
                return Transform.translate(
                  offset: Offset(value * (constraints.maxWidth - 8), 0),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.redAccent.withValues(alpha:0.6),
                          blurRadius: 10,
                          spreadRadius: 3,
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
          // Loops the animation
          onEnd: () {},
        ),
      ],
    );
  }
}