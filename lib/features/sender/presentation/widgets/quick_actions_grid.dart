import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:kgl_express/features/sender/presentation/ServiceSelectionScreen.dart';
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
                color: Colors.green[700]!, // Darker green for logistics
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
              QuickActionCard(
                title: "Track Order",
                icon: Icons.near_me,
                color: Colors.orange[800]!,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const KigaliMapPage())
                ),
              ),
              QuickActionCard(
                title: "History",
                icon: Icons.history,
                color: Colors.blue,
                onTap: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryScreen()));
                },
              ),
              QuickActionCard(
                title: "Payments",
                icon: Icons.account_balance_wallet,
                color: Colors.purple,
                onTap: () {
                  // Action pour les paiements
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

