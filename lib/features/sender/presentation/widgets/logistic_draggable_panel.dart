import 'package:flutter/material.dart';
import 'package:kgl_express/core/constants/mock_data.dart';
import 'package:kgl_express/core/enums/order_status.dart';
import 'package:kgl_express/features/sender/presentation/widgets/detail_row.dart';
import 'package:kgl_express/features/sender/presentation/widgets/package_card.dart';
import 'package:kgl_express/features/sender/presentation/widgets/payment_summary.dart';
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
         initialChildSize: 0.35,
         minChildSize: 0.2,
         maxChildSize: 0.9,
         builder: (context, scrollController) {
           return Container(
             decoration: BoxDecoration(
               color: Colors.white.withValues(alpha: 0.95),
               borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
               boxShadow: [
                 BoxShadow(
                   color: Colors.black.withValues(alpha: 0.05),
                   blurRadius: 10,
                   spreadRadius: 5,
                 )
               ],
             ),
             child: ClipRRect(
               borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
               child: ListView.builder(
                 controller: scrollController,
                 padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                 // We use +1 to account for the header/actions section
                 itemCount: mockOrders.length + 1,
                 itemBuilder: (context, index) {
                   // The first item (index 0) is your header and horizontal actions
                   if (index == 0) {
                     return _buildHeaderSection(context);
                   }

                   // Subsequent items are your dynamic orders
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
     // 1. Get ALL orders that are 'inTransit'
     final activeOrders = mockOrders.where((o) => o.status == OrderStatus.inTransit).toList();

     return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         // --- Drag Handle ---
         Center(
           child: Container(
             width: 45,
             height: 5,
             decoration: BoxDecoration(
               color: Colors.grey[300],
               borderRadius: BorderRadius.circular(10),
             ),
           ),
         ),
         const SizedBox(height: 25),

         // --- 2. Live Tracking Carousel (Conditional) ---
         if (activeOrders.isNotEmpty) ...[
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               const Text(
                 "Live Tracking",
                 style: TextStyle(
                   fontSize: 14,
                   fontWeight: FontWeight.bold,
                   color: Colors.blueAccent,
                   letterSpacing: 0.5,
                 ),
               ),
               if (activeOrders.length > 1)
                 Text(
                   "Active: ${activeOrders.length}",
                   style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.bold),
                 ),
             ],
           ),
           const SizedBox(height: 12),

           // Carousel for multiple orders
           SizedBox(
             height: 145, // Adjusted height to fit content
             child: PageView.builder(
               itemCount: activeOrders.length,
               controller: PageController(viewportFraction: 0.95), // Shows a peek of the next card
               padEnds: false,
               itemBuilder: (context, index) {
                 return Padding(
                   padding: const EdgeInsets.only(right: 12),
                   child: LiveTrackingCard(order:activeOrders[index]),
                 );
               },
             ),
           ),
           const SizedBox(height: 30),
         ],

         // --- Quick Actions Header ---
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             const Text(
               "Quick Actions",
               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
             ),
             TextButton(
               onPressed: () {},
               child: const Text("View All", style: TextStyle(color: Colors.blue)),
             ),
           ],
         ),
         const SizedBox(height: 15),

         // --- Horizontal Scrollable Actions ---
         SizedBox(
           height: 115,
           child: ListView(
             scrollDirection: Axis.horizontal,
             physics: const BouncingScrollPhysics(),
             children: [
               _buildActionCard("Send Item", Icons.local_shipping, Colors.green),
               _buildActionCard("Track", Icons.location_on, Colors.orange),
               _buildActionCard("History", Icons.history, Colors.blue),
               _buildActionCard("Payments", Icons.account_balance_wallet, Colors.purple),
             ],
           ),
         ),

         const SizedBox(height: 35),
         const Text(
           "Recent Activity",
           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
         ),
         const SizedBox(height: 15),
       ],
     );
   }

  // Helper for the Action Cards
  Widget _buildActionCard(String title, IconData icon, Color color) {
    return Container(
      width: 105,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha:0.2), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha:0.2),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              color: color.withValues(alpha:0.8),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
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


