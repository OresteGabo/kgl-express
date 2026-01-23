import 'package:flutter/material.dart';
import 'package:kgl_express/core/constants/mock_data.dart';
import 'package:kgl_express/core/enums/order_status.dart';
import 'package:kgl_express/features/sender/presentation/widgets/package_card.dart';
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
                   child: _buildLiveTrackingCard(activeOrders[index]),
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

   Widget _buildLiveTrackingCard(OrderModel order) {
     return Container(
       padding: const EdgeInsets.all(20),
       decoration: BoxDecoration(
         color: Colors.black,
         borderRadius: BorderRadius.circular(24),
       ),
       child: Column(
         children: [
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               _locationInfo(order.pickupLocation, "PICKUP"),
               Column(
                 children: [
                   const Icon(Icons.moped, color: Colors.white70, size: 18),
                   Text(order.id.toUpperCase(),
                       style: const TextStyle(color: Colors.white38, fontSize: 8)),
                 ],
               ),
               _locationInfo(order.destination, "DESTINATION"),
             ],
           ),
           const SizedBox(height: 20),

           // --- Animated Progress Line (Dashed) ---
           Stack(
             children: [
               Row(
                 children: List.generate(
                   15,
                       (index) => Expanded(
                     child: Container(
                       margin: const EdgeInsets.symmetric(horizontal: 2),
                       height: 2,
                       decoration: BoxDecoration(
                         color: Colors.white.withOpacity(0.1),
                         borderRadius: BorderRadius.circular(2),
                       ),
                     ),
                   ),
                 ),
               ),
               TweenAnimationBuilder<double>(
                 tween: Tween(begin: 0.0, end: 1.0),
                 duration: const Duration(seconds: 4),
                 builder: (context, value, child) {
                   return FractionalTranslation(
                     translation: Offset(value * 10, 0), // Adjust multiplier to match line length
                     child: Container(
                       width: 8,
                       height: 8,
                       decoration: BoxDecoration(
                         color: Colors.redAccent,
                         shape: BoxShape.circle,
                         boxShadow: [
                           BoxShadow(
                             color: Colors.redAccent.withOpacity(0.6),
                             blurRadius: 8,
                             spreadRadius: 2,
                           )
                         ],
                       ),
                     ),
                   );
                 },
               ),
             ],
           ),
         ],
       ),
     );
   }



// Sub-helper for location text in the live card
  Widget _locationInfo(String location, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 9, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          location,
          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
        ),
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
                _buildLiveDetailsHeader(order)
              else
                _buildStandardDetailsHeader(order),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // Logistics Info
                    _detailRow(Icons.location_on_outlined, "From", order.pickupLocation),
                    _detailRow(Icons.flag_outlined, "To", order.destination),
                    _detailRow(Icons.person_pin_circle, "Recipient Info", "${order.recipientPhone}\n${order.pickupNotes}"),

                    const SizedBox(height: 20),
                    const Text("Items in Package", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),

                    // Items List Container
                    _buildItemsList(order),

                    const Divider(height: 40),

                    // Payment Summary
                    _buildPaymentSummary(order),

                    const SizedBox(height: 30),
                    _buildTrackButton(context, order),
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
Widget _buildItemsList(OrderModel order) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey[50], // Light background for contrast
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.grey[200]!),
    ),
    child: Column(
      children: order.items.map((item) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quantity Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                "${item.quantity}x",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Item Name & Description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  if (item.description != null && item.description!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        item.description!,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      )).toList(),
    ),
  );
}
Widget _buildLiveDetailsHeader(OrderModel order) {
  return Container(
    padding: const EdgeInsets.fromLTRB(24, 12, 24, 30),
    decoration: const BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    child: Column(
      children: [
        // Handle bar for the modal
        Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)))),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("LIVE TRACKING", style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                Text(order.title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(8)),
              child: Text("#${order.id.toUpperCase()}", style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
            )
          ],
        ),
        const SizedBox(height: 30),

        // The Animation
        Stack(
          alignment: Alignment.center,
          children: [
            Row(
              children: List.generate(20, (i) => Expanded(
                child: Container(margin: const EdgeInsets.symmetric(horizontal: 2), height: 1, color: Colors.white24),
              )),
            ),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(seconds: 3),
              builder: (context, value, child) {
                return FractionalTranslation(
                  translation: Offset(value * 15 - 7.5, 0), // Travels back and forth
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.redAccent, blurRadius: 15, spreadRadius: 4)],
                    ),
                  ),
                );
              },
            ),
            const Icon(Icons.moped, color: Colors.white, size: 24),
          ],
        ),
      ],
    ),
  );
}

Widget _buildStandardDetailsHeader(OrderModel order) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
    child: Column(
      children: [
        Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(order.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text("#${order.id.toUpperCase()}", style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
      ],
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

Widget _buildTrackButton(BuildContext context, OrderModel order) {
  final isLive = order.status == OrderStatus.inTransit;

  return SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      onPressed: () => Navigator.pop(context),
      icon: Icon(isLive ? Icons.map : Icons.arrow_back, color: Colors.white),
      label: Text(isLive ? "Open Live Map" : "Back to List",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: isLive ? Colors.blueAccent : Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 0,
      ),
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
