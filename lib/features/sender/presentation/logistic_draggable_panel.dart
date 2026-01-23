import 'package:flutter/material.dart';
import 'package:kgl_express/core/constants/mock_data.dart';
import 'package:kgl_express/features/sender/presentation/package_card.dart';
import 'package:kgl_express/models/order_model.dart';



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
                     return _buildHeaderSection();
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

   Widget _buildHeaderSection() {
     return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
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
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             const Text(
               "Quick Actions",
               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
             ),
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
               _buildActionCard("Send Item", Icons.local_shipping, Colors.green),
               _buildActionCard("Track", Icons.location_on, Colors.orange),
               _buildActionCard("History", Icons.history, Colors.blue),
               _buildActionCard("Payments", Icons.account_balance_wallet, Colors.purple),
             ],
           ),
         ),
         const SizedBox(height: 35),
         const Text(
           "Recent Deliveries",
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
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allows the sheet to expand for many items
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.6, // Start at 60% of screen
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Order Details", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(6)),
                  child: Text("#${order.id.toUpperCase()}", style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
            const Divider(height: 40),

            // Logistics Info
            _detailRow(Icons.location_on_outlined, "From", order.pickupLocation),
            _detailRow(Icons.flag_outlined, "To", order.destination),
            _detailRow(Icons.person_pin_circle, "Recipient Info", "${order.recipientPhone}\n${order.pickupNotes}"),

            const SizedBox(height: 20),
            const Text("Items in Package", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // --- THE DYNAMIC ITEMS LIST ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: order.items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0), // More breathing room
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start, // Align icon/quantity to top
                    children: [
                      Text(
                          "${item.quantity}x",
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 14)
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                item.name,
                                style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 14)
                            ),
                            if (item.description != null && item.description!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  item.description!,
                                  style: TextStyle(color: Colors.grey[600], fontSize: 12, fontStyle: FontStyle.italic),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ),
            ),

            const Divider(height: 40),

            // Payment Summary
            _buildPaymentSummary(order),

            const SizedBox(height: 30),
            _buildTrackButton(context),
          ],
        ),
      ),
    ),
  );
}
Widget _buildPaymentSummary(OrderModel order) {
  final method = order.paymentMethod;

  return Row(
    children: [
      Container(
        width: 40,
        height: 40,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: method.assetPath != null
            ? Image.asset(
          method.assetPath!,
          fit: BoxFit.contain,
        )
            : Icon(
          method.icon,
          color: Colors.blueGrey,
          size: 20,
        ),
      ),
      const SizedBox(width: 12),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Payment Method",
            style: TextStyle(color: Colors.grey, fontSize: 11),
          ),
          Text(
            method.label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      const Spacer(),
      Text(
        "${order.price.toInt()} RWF",
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w900,
          color: Colors.black,
        ),
      ),
    ],
  );
}

Widget _buildTrackButton(BuildContext context) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () => Navigator.pop(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 0,
      ),
      child: const Text("Track Live Delivery", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    ),
  );
}

Widget _detailRow(IconData icon, String title, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Row(
      children: [
        Icon(icon, color: Colors.grey[400], size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          ],
        ),
      ],
    ),
  );
}
