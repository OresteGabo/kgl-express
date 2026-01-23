import 'package:flutter/material.dart';
import 'package:kgl_express/core/enums/order_status.dart';
import 'package:kgl_express/features/sender/presentation/widgets/detail_row.dart';
import 'package:kgl_express/models/order_model.dart';

import 'package:kgl_express/features/sender/presentation/widgets/items_list.dart';
import 'package:kgl_express/features/sender/presentation/widgets/payment_summary.dart';
import 'package:kgl_express/features/sender/presentation/widgets/track_button.dart';

void showOrderDetailsSheet(BuildContext context, OrderModel order) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => OrderDetailsContent(order: order, scrollController: scrollController),
    ),
  );
}

class OrderDetailsContent extends StatelessWidget {
  final OrderModel order;
  final ScrollController scrollController;

  const OrderDetailsContent({super.key, required this.order, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final bool isInTransit = order.status == OrderStatus.inTransit;
    return Container(
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            isInTransit ? LiveDetailsHeader(order: order) : StandardDetailsHeader(order: order),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  DetailRow(icon: Icons.location_on, title: "From", value: order.pickupLocation),
                  DetailRow(icon: Icons.flag, title: "To", value: order.destination),
                  ItemsList(order: order),
                  const Divider(height: 40),
                  PaymentSummary(order: order),
                  const SizedBox(height: 30),
                  TrackButton(order: order),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class LiveDetailsHeader extends StatelessWidget {
  final OrderModel order;

  const LiveDetailsHeader({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          // Modal Drag Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 25),

          // Header Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildLivePulse(),
                        const SizedBox(width: 8),
                        const Text(
                          "IN TRANSIT",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      order.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "#${order.id.toUpperCase()}",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 40),

          // Live Animation Track
          _buildTrackingAnimation(),
        ],
      ),
    );
  }

  Widget _buildLivePulse() {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: Colors.redAccent,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildTrackingAnimation() {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // The Track Line
        Row(
          children: List.generate(24, (i) => Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1.5),
              height: 1.5,
              color: Colors.white.withValues(alpha:0.1),
            ),
          )),
        ),
        // The Pulse Dot
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(seconds: 3),
          builder: (context, value, child) {
            // Using Sinusoidal movement to go back and forth
            return FractionalTranslation(
              translation: Offset((value * 12) - 6, 0),
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha:0.3),
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(color: Colors.redAccent, blurRadius: 12, spreadRadius: 2)
                  ],
                ),
              ),
            );
          },
        ),
        // Stationary Central Icon
        const CircleAvatar(
          backgroundColor: Colors.black,
          radius: 18,
          child: Icon(Icons.moped, color: Colors.white, size: 22),
        ),
      ],
    );
  }
}


class StandardDetailsHeader extends StatelessWidget {
  final OrderModel order;

  const StandardDetailsHeader({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Modal Drag Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 25),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "#${order.id.toUpperCase()}",
                  style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Order details and manifest",
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
          const Divider(height: 40, thickness: 1),
        ],
      ),
    );
  }
}