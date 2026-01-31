import 'package:flutter/material.dart';
import 'package:kgl_express/core/constants/mock_data.dart';
import 'package:kgl_express/core/enums/order_status.dart';
import 'package:kgl_express/features/sender/presentation/widgets/detail_row.dart';
import 'package:kgl_express/features/sender/presentation/widgets/package_card.dart';
import 'package:kgl_express/features/sender/presentation/widgets/payment_summary.dart';
import 'package:kgl_express/features/sender/presentation/widgets/quick_actions_grid.dart';
import 'package:kgl_express/features/sender/presentation/widgets/track_button.dart';
import 'package:kgl_express/models/order_model.dart';

import 'items_list.dart';
import 'live_tracking_card.dart';
import 'order_details_sheet.dart';



class LogisticsDraggablePanel extends StatelessWidget {
  const LogisticsDraggablePanel({
    super.key,
    required this.scrollNotifier,
  });
  final ValueNotifier<double> scrollNotifier;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        scrollNotifier.value = notification.extent;
        return true;
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.45,
        minChildSize: 0.2,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              // REMOVED: Pure black shadows and harsh whites
              color: const Color(0xFFF8F9FA), // Softer off-white
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1A1C1E).withOpacity(0.08), // Soft Charcoal shadow
                  blurRadius: 20,
                  spreadRadius: 2,
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                itemCount: mockOrders.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) return _buildHeaderSection(context);

                  final order = mockOrders[index - 1];
                  return PackageCard(
                    order: order,
                    onTap: () => _showPackageDetails(context, order),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    final activeOrders = mockOrders.where((o) => o.status == OrderStatus.inTransit).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Drag Handle (Softer Gray) ---
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 24),

        if (activeOrders.isNotEmpty) ...[
          // --- Section Title: Removed Red/Aggressive Blue ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Live Tracking",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2D3135), // Soft Dark Gray (No more pure black)
                  letterSpacing: -0.5,
                ),
              ),
              if (activeOrders.length > 1)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.1), // Soft Teal Badge
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${activeOrders.length} ACTIVE",
                    style: const TextStyle(
                        color: Colors.teal,
                        fontSize: 10,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // --- Horizontal Carousel ---
          SizedBox(
            height: 200, // Fixed height for the new vertical-style cards
            child: PageView.builder(
              itemCount: activeOrders.length,
              controller: PageController(viewportFraction: 0.92),
              padEnds: false,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: LiveTrackingCard(order: activeOrders[index]),
                );
              },
            ),
          ),
          const SizedBox(height: 32),
        ],

        const QuickActionsGrid(),

        const SizedBox(height: 32),
        const Text(
          "Recent Activity",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Color(0xFF2D3135),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _showPackageDetails(BuildContext context, OrderModel order) {
    final bool isInTransit = order.status == OrderStatus.inTransit;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Allow custom styling
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- DYNAMIC HEADER ---
                if (isInTransit)
                  LiveDetailsHeader(order:order)
                else
                  StandardDetailsHeader(order:order),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      // Logistics Info
                      DetailRow(
                          icon: Icons.location_on_outlined,
                          title: "From",
                          value: order.pickupLocation
                      ),

                      DetailRow(
                          icon: Icons.flag_outlined,
                          title: "To",
                          value: order.destination
                      ),

                      DetailRow(
                          icon: Icons.person_pin_circle,
                          title: "Recipient Info",
                          value: "${order.recipientPhone}\n${order.pickupNotes}"
                      ),
                      const SizedBox(height: 20),


                      // Items List Container
                      ItemsList(order:order),

                      const Divider(height: 40),

                      // Payment Summary
                      PaymentSummary( order: order),

                      const SizedBox(height: 30),
                      TrackButton( order:order),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



