import 'package:flutter/material.dart';
import 'package:kgl_express/features/sender/presentation/bus_booking_screen.dart';
import 'package:kgl_express/features/sender/presentation/service_selection_screen.dart';
import 'package:kgl_express/features/sender/presentation/create_order_screen.dart';
import 'package:kgl_express/features/sender/presentation/widgets/quick_action_card.dart';

import '../../../map/presentation/pages/kigali_map_page.dart';


class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Quick Actions", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextButton(onPressed: () {}, child: const Text("View All")),
          ],
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 115,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              QuickActionCard(
                title: "Send Item",
                icon: Icons.local_shipping,
                color: Colors.green[700]!,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateOrderScreen())
                ),
              ),
              QuickActionCard(
                title: "Order Service",
                icon: Icons.design_services,
                color: Colors.teal[600]!,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ServiceSelectionScreen())
                ),
              ),
              // NEW: Bus Tickets Action
              QuickActionCard(
                title: "Transport", // "Mobility" or "Travel" also work well
                icon: Icons.explore_outlined, // Compass or Route icon feels more "super-app"
                color: Colors.deepOrange[700]!,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BusBookingScreen())
                ),

                  /**
                   * TODO: Implement Transport & Travel Hub
                   * * UI STRUCTURE:
                   * - Tab 1: "Kigali City" (Commute)
                   * - Features: Tap&Go card balance, Route maps, City Bus schedules (KBS, Royal Express, RFTC).
                   * - Real-time: Integration with 'Pickup Rwanda' style tracking if possible.
                   * * - Tab 2: "Upcountry" (Inter-city)
                   * - Focus: Long-distance booking (Volcano, Horizon, Ritco, Stella, etc.).
                   * - Logic: Seat selection, Luggage space booking, Departure notifications.
                   * * - Tab 3 (Future): "Rentals & Bikes"
                   * - Car rentals (VW Move, Private agencies).
                   * - Electric/Bicycle rentals (Guraride).
                   * * SHARED LOGIC:
                   * - Payment: MOMO/Airtel Money (Push USSD).
                   * - Ticket: QR code generation for offline scanning.
                   * */

              ),
              QuickActionCard(
                title: "Real Estate",
                isActivated: false, // Deactivated for now
                icon: Icons.home_work, // Better icon for buildings + land
                color: Colors.indigo[900]!, // Deep premium color for high-value assets
                onTap: () {
                  /**
                   *  TODO: Navigate to Real Estate Hub.
                   * This screen should have a TabBar: [Rent, Buy, Sell]
                   *
                   *'Buy' section should include:
                   * - Residential (Houses/Apartments)
                   * - Commercial
                   * - Plots/Land (Extremely popular in Rwanda)
                   *
                   * 'Sell' section:
                   * - A "List my Property" button (Monetization: Charge for 'Premium' listings)
                   * */
                },
              ),
              QuickActionCard(
                title: "History", // Combined name
                icon: Icons.history,
                color: Colors.blue[800]!,
                onTap: () => Navigator.push(
                    context,
                    // we need to modify KigaliMapPage even its name Navigate to a screen with Tabs: [Active, Completed, Scheduled]
                    MaterialPageRoute(builder: (context) => const KigaliMapPage())
                ),
              ),
              QuickActionCard(
                title: "Payments",
                icon: Icons.account_balance_wallet,
                color: Colors.purple,
                onTap: () {},
              ),

            ],
          ),
        ),
      ],
    );
  }
}

