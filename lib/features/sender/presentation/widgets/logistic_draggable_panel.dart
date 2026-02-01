import 'package:flutter/material.dart';
import 'package:kgl_express/core/constants/mock_data.dart';
import 'package:kgl_express/core/enums/order_status.dart';
import 'package:kgl_express/features/sender/presentation/widgets/detail_row.dart';
import 'package:kgl_express/features/sender/presentation/widgets/package_card.dart';
import 'package:kgl_express/features/sender/presentation/widgets/payment_summary.dart';
import 'package:kgl_express/features/sender/presentation/widgets/quick_actions_grid.dart';
import 'package:kgl_express/features/sender/presentation/widgets/track_button.dart';
import 'package:kgl_express/models/order_model.dart';
import 'package:marquee/marquee.dart';

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
    // 1. FILTER LIVE ACTIVITIES (Moving or Active)
    final liveActivities = mockOrders.where((o) {
      if (o is OrderModel) return o.status == OrderStatus.inTransit;
      if (o is BusTicketModel) return o.isActive;
      return false;
    }).toList();

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
              color: const Color(0xFFF8F9FA),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1A1C1E).withValues(alpha: 0.08),
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
                // +1 for the Header Section
                itemCount: mockOrders.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) return _buildHeaderSection(context, liveActivities);

                  // 2. RECENT ACTIVITY LIST (Items after index 0)
                  final item = mockOrders[index - 1];
                  return PackageCard(
                    item: item,
                    onTap: () => _handleItemTap(context, item),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, List<Object> liveActivities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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

        if (liveActivities.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Live Tracking",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2D3135),
                  letterSpacing: -0.5,
                ),
              ),
              if (liveActivities.length > 1)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.teal.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${liveActivities.length} ACTIVE",
                    style: const TextStyle(color: Colors.teal, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          SizedBox(
            height: 200,
            child: PageView.builder(
              itemCount: liveActivities.length,
              controller: PageController(viewportFraction: 0.92),
              padEnds: false,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  // FACTORY USAGE
                  child: LiveActivityFactory.createCard(liveActivities[index], context),
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

  // Handle generic object tap
  void _handleItemTap(BuildContext context, Object item) {
    if (item is OrderModel) {
      _showPackageDetails(context, item);
    } else if (item is BusTicketModel) {
      _showTicketDetails(context, item); // Call the new ticket sheet
    }
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

  void _showTicketDetails(BuildContext context, BusTicketModel ticket) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Color(0xFFF8F9FA),
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Drag Handle
            Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10)
                )
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // --- OPERATOR & LOGO SECTION ---
                    Row(
                      children: [
                        if (ticket.operatorLogo != null)
                          Image.asset(ticket.operatorLogo!, width: 50, height: 50)
                        else
                          const CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.deepOrange,
                            child: Icon(Icons.directions_bus, color: Colors.white, size: 28),
                          ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                ticket.operator,
                                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)
                            ),
                            Text(
                                "Ticket ID: ${ticket.activityId}",
                                style: TextStyle(color: Colors.grey[500], fontSize: 11)
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // --- THE ROUTE SECTION (Now with code below) ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center, // Vertically aligns text and icon
                      children: [
                        _TicketStation(
                          city: ticket.from, // e.g. "Nyabugogo"
                          label: "Origin",
                        ),

                        // The "Middle" Indicator
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                                Icons.chevron_right_rounded,
                                color: Colors.deepOrange,
                                size: 24
                            ),
                          ),
                        ),

                        _TicketStation(
                          city: ticket.to, // e.g. "Huye Main Station"
                          label: "Destination",
                          align: CrossAxisAlignment.end,
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // --- TICKET BODY ---
                    // Inside the _showTicketDetails function, replace the Container(child: Column(...)) with this:

                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 20,
                              offset: const Offset(0, 10)
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          // --- LIVE OPERATOR STATUS ---
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green.withValues(alpha: 0.1)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.info_outline, color: Colors.green, size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "Operator: Bus has arrived at Nyabugogo. You can now board.",
                                    style: TextStyle(
                                        color: Colors.green[700],
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // --- PASSENGER & PLATE ---
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _InfoBlock(label: "PASSENGER", value: ticket.passengerName),
                              const SizedBox(width: 20), // Spacer
                              _InfoBlock(
                                  label: "CAR PLATE",
                                  value: ticket.carPlate,
                                  isHighlight: true
                              ),
                            ],
                          ),

                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Divider(color: Color(0xFFF1F1F1), height: 1),
                          ),

                          // --- DATE & TIME ---
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _InfoBlock(label: "DEPARTURE DATE", value: "Feb 12, 2026"),
                              _InfoBlock(label: "TIME", value: "09:30 AM"),
                            ],
                          ),

                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Divider(color: Color(0xFFF1F1F1), height: 1),
                          ),

                          // --- PAYMENT ---
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _InfoBlock(
                                  label: "PAYMENT METHOD",
                                  value: ticket.paymentMethod.label
                              ),
                              ticket.paymentMethod.assetPath != null
                                  ? Image.asset(ticket.paymentMethod.assetPath!, width: 32)
                                  : Icon(ticket.paymentMethod.icon, size: 28, color: Colors.blueGrey),
                            ],
                          ),
                          const SizedBox(height: 40),

                          // --- DATA MATRIX ---
                          const Icon(Icons.grid_view_rounded, size: 180, color: Colors.black),
                          const SizedBox(height: 12),
                          const Text(
                              "SCAN AT BOARDING",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                  fontSize: 10,
                                  color: Colors.grey
                              )
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}


class _TicketStation extends StatelessWidget {
  final String city, label;
  final CrossAxisAlignment align;

  const _TicketStation({
    required this.city,
    required this.label,
    this.align = CrossAxisAlignment.start,
  });

  // Simple helper for Rwanda city codes
  String _getCityCode(String cityName) {
    final name = cityName.toUpperCase();
    if (name.contains("NYABUGOGO") || name.contains("KIGALI")) return "KGL";
    if (name.contains("HUYE") || name.contains("BUTARE")) return "BTR";
    if (name.contains("MUSANZE")) return "MSZ";
    if (name.contains("RUBAVU")) return "RBV";
    return name.length >= 3 ? name.substring(0, 3) : name;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded( // Allows the column to take available space without overflow
      child: Column(
        crossAxisAlignment: align,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          // Animating Long City Names
          SizedBox(
            height: 28,
            child: city.length > 12
                ? Marquee(
              text: city.toUpperCase(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1A1C1E),
              ),
              scrollAxis: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              blankSpace: 20.0,
              velocity: 30.0,
              pauseAfterRound: const Duration(seconds: 2),
            )
                : Text(
              city.toUpperCase(),
              textAlign: align == CrossAxisAlignment.end ? TextAlign.right : TextAlign.left,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1A1C1E),
              ),
            ),
          ),
          // City Code (Small & Subtle)
          Text(
            _getCityCode(city),
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final String label, value;
  final bool isHighlight;

  const _InfoBlock({
    required this.label,
    required this.value,
    this.isHighlight = false
  });

  @override
  Widget build(BuildContext context) {
    return Flexible( // Prevents this block from pushing the other out of bounds
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              label,
              style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 9,
                  fontWeight: FontWeight.bold
              )
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 20,
            child: value.length > 15
                ? Marquee(
              text: value.toUpperCase(),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: isHighlight ? Colors.deepOrange : Colors.black,
              ),
              blankSpace: 20,
              velocity: 30,
              pauseAfterRound: const Duration(seconds: 2),
            )
                : Text(
              value.toUpperCase(),
              maxLines: 1,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: isHighlight ? Colors.deepOrange : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketInfo extends StatelessWidget {
  final String label, value;
  const _TicketInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
