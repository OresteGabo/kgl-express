import 'package:flutter/material.dart';
import 'package:kgl_express/features/sender/presentation/create_order_screen.dart';
import 'package:kgl_express/features/sender/presentation/widgets/quick_action_card.dart';


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
                color: Colors.green,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateOrderScreen())),
              ),
              QuickActionCard(
                title: "Track",
                icon: Icons.location_on,
                color: Colors.orange,
                onTap: () {
                  // Action pour le tracking (ex: ouvrir une map ou un historique actif)
                },
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