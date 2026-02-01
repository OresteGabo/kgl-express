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

  // Refactored Ticket Details Section
  void _showTicketDetails(BuildContext context, BusTicketModel ticket) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        // Use a Wrap or a ConstrainedBox to give Flutter a clear size target
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.pop(context), // Close when tapping outside
          child: DraggableScrollableSheet(
            initialChildSize: 0.85,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            expand: false, // This is key
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Stack( // Using Stack to keep handle fixed at top
                  children: [
                    ListView( // Using ListView instead of SingleChildScrollView + Column
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                      children: [
                        _buildTicketHeader(ticket),
                        const SizedBox(height: 30),
                        _buildRouteSection(ticket),
                        const SizedBox(height: 30),
                        _buildTicketMainBody(ticket),
                        // Extra space for bottom notch
                        SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
                      ],
                    ),
                    // Fixed Drag Handle
                    Positioned(
                      top: 12,
                      left: 0,
                      right: 0,
                      child: Center(child: _buildDragHandle()),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

// 1. HELPER: Drag Handle
  Widget _buildDragHandle() {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

// 2. HELPER: Operator & Logo
  Widget _buildTicketHeader(BusTicketModel ticket) {
    return Row(
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
            Text(ticket.operator,
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            Text("Ticket ID: ${ticket.activityId}",
                style: TextStyle(color: Colors.grey[500], fontSize: 11)),
          ],
        ),
      ],
    );
  }

// 3. HELPER: The Route Section (Now using Column to avoid overflow)
  Widget _buildRouteSection(BusTicketModel ticket) {
    return Row( // Use a Row to put the "Path" next to the "Names"
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // THE VISUAL PATH (Left Side)
        Column(
          children: [
            Icon(Icons.radio_button_unchecked, size: 16, color: Colors.grey[400]),
            Container(
              width: 2,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                // You can use a CustomPainter for a dashed line here
              ),
            ),
            const Icon(Icons.location_on, size: 18, color: Colors.deepOrange),
          ],
        ),
        const SizedBox(width: 20),
        // THE STATION NAMES (Right Side)
        Flexible( // Add this to prevent overflow if city names are very long
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TicketStation(city: ticket.from, label: "Origin", align: CrossAxisAlignment.start),
              const SizedBox(height: 12),
              _TicketStation(city: ticket.to, label: "Destination", align: CrossAxisAlignment.start),
            ],
          ),
        ),
      ],
    );
  }



// 4. HELPER: Main Ticket Card
  Widget _buildTicketMainBody(BusTicketModel ticket) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align labels to the left
        children: [
          _buildStatusBanner("Operator: Bus has arrived at Nyabugogo. You can now board."),
          const SizedBox(height: 24),

          // 1. PASSENGER (Full Width)
          _InfoBlock(
            label: "PASSENGER",
            value: ticket.passengerName,
            // You might want to update _InfoBlock to not use Flexible when it's full width
          ),

          const Divider(height: 32, color: Color(0xFFF1F1F1)),

          // 2. CAR PLATE & PAYMENT (Grouped together)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _InfoBlock(
                  label: "CAR PLATE",
                  value: ticket.carPlate,
                  isHighlight: true
              ),
              _buildPaymentChip(ticket),
            ],
          ),

          const Divider(height: 32, color: Color(0xFFF1F1F1)),

          // 3. DATE & TIME
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _InfoBlock(label: "DEPARTURE DATE", value: "Feb 12, 2026"),
              _InfoBlock(label: "TIME", value: "09:30 AM"),
            ],
          ),

          const SizedBox(height: 40),

          // QR/Data Matrix Section
          Center(
            child: Column(
              children: [
                const Icon(Icons.qr_code_2_outlined, size: 160, color: Colors.black),
                const SizedBox(height: 12),
                const Text(
                  "SCAN AT BOARDING",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Helper for the Success Payment Chip
  Widget _buildPaymentChip(BusTicketModel ticket) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "PAYMENT STATUS",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.green.withValues(alpha: 0.15)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. PAYMENT LOGO OR ICON
              if (ticket.paymentMethod.assetPath != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Image.asset(
                    ticket.paymentMethod.assetPath!,
                    width: 16,
                    height: 16,
                    fit: BoxFit.contain,
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: Icon(
                    ticket.paymentMethod.icon ?? Icons.account_balance_wallet,
                    color: Colors.green[700],
                    size: 14,
                  ),
                ),

              // 2. PAYMENT LABEL
              Text(
                ticket.paymentMethod.label.toUpperCase(),
                style: TextStyle(
                  color: Colors.green[800],
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(width: 8),

              // 3. SUCCESS CHECKMARK
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 14,
              ),
            ],
          ),
        ),
      ],
    );
  }
// 5. SMALL HELPERS for reusable UI components
  Widget _buildStatusBanner(String message) {
    return Container(
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
            child: Text(message,
                style: TextStyle(color: Colors.green[700], fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(BusTicketModel ticket) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _InfoBlock(label: "PAYMENT METHOD", value: ticket.paymentMethod.label),
        ticket.paymentMethod.assetPath != null
            ? Image.asset(ticket.paymentMethod.assetPath!, width: 32)
            : Icon(ticket.paymentMethod.icon, size: 28, color: Colors.blueGrey),
      ],
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
    const textStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w900,
      color: Color(0xFF1A1C1E),
    );

    return Column(
      crossAxisAlignment: align,
      mainAxisSize: MainAxisSize.min,
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

        // --- SMART ANIMATION LOGIC ---
        LayoutBuilder(
          builder: (context, constraints) {
            final String upperCity = city.toUpperCase();

            // Measure the width of the text
            final textPainter = TextPainter(
              text: TextSpan(text: upperCity, style: textStyle),
              maxLines: 1,
              textDirection: TextDirection.ltr,
            )..layout();

            // If text width > available width, use Marquee
            if (textPainter.width > constraints.maxWidth) {
              return SizedBox(
                height: 28,
                child: Marquee(
                  text: upperCity,
                  style: textStyle,
                  scrollAxis: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  blankSpace: 40.0, // Increased space for clarity
                  velocity: 30.0,
                  pauseAfterRound: const Duration(seconds: 2),
                ),
              );
            }

            // Otherwise, just show normal text
            return SizedBox(
              height: 28,
              child: Text(
                upperCity,
                textAlign: align == CrossAxisAlignment.end ? TextAlign.right : TextAlign.left,
                style: textStyle,
              ),
            );
          },
        ),

        Text(
          _getCityCode(city),
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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
    return Column(
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
    );
  }
}

