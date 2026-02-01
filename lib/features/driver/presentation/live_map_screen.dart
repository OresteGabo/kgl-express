import 'package:flutter/material.dart';
import 'package:kgl_express/core/presentation/widgets/kigali_map_painter.dart';
import 'package:kgl_express/features/sender/presentation/widgets/detail_row.dart';
import 'package:kgl_express/models/order_model.dart';
import 'package:kgl_express/core/constants/mock_data.dart';

class LiveMapScreen extends StatelessWidget {
  final OrderModel? order;

  const LiveMapScreen({super.key, this.order});

  @override
  Widget build(BuildContext context) {
    // Use the passed order or fallback to the first mock order
    final displayOrder = order ?? mockOrders.first;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          // 1. THE MAP LAYER (Custom Painted Map of Kigali)
          Positioned.fill(
            child: InteractiveViewer(
              maxScale: 5.0,
              minScale: 0.5,
              child: CustomPaint(
                painter: KigaliMapPainter(),
                size: Size.infinite,
              ),
            ),
          ),

          // 2. TOP OVERLAY (Back button and Status)
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircularButton(
                  icon: Icons.arrow_back_ios_new,
                  onTap: () => Navigator.pop(context),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha:0.1),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.circle, color: Colors.green, size: 12),
                      SizedBox(width: 8),
                      Text(
                        "LIVE TRACKING",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 40), // Balance the back button
              ],
            ),
          ),

          // 3. BOTTOM PANEL (Order Details)
          // This reuses the logic we fixed earlier with DetailRow
          DraggableScrollableSheet(
            initialChildSize: 0.35,
            minChildSize: 0.15,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 20, spreadRadius: 5)
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        const SizedBox(height: 20),
                        Text(
                          "Order #${displayOrder.id.substring(0, 8)}",
                          style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "In Transit to Destination",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const Divider(height: 40),

                        // Reusing our DetailRow class (Uppercase D)
                        DetailRow(
                          icon: Icons.motorcycle,
                          title: "Rider",
                          value: "Jean Bosco (Moto - RAE 123 A)",
                        ),
                        DetailRow(
                          icon: Icons.location_on,
                          title: "Current Location",
                          value: "Near Kigali Convention Centre",
                        ),
                        DetailRow(
                          icon: Icons.timer,
                          title: "Estimated Arrival",
                          value: "12 Minutes",
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Icon(icon, size: 20, color: Colors.black),
      ),
    );
  }
}