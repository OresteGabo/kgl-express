import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kgl_express/core/enums/order_status.dart';
import 'package:kgl_express/features/sender/presentation/widgets/detail_row.dart';
import 'package:kgl_express/models/order_model.dart';

import 'package:kgl_express/features/sender/presentation/widgets/items_list.dart';
import 'package:kgl_express/features/sender/presentation/widgets/payment_summary.dart';
import 'package:kgl_express/features/sender/presentation/widgets/track_button.dart';

void showOrderDetailsSheet(BuildContext context, OrderModel order) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.2,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => OrderDetailsContent(order: order, scrollController: scrollController),
    ),
  );
}

class OrderDetailsContent extends StatelessWidget {
  final OrderModel order;
  final ScrollController scrollController;

  const OrderDetailsContent({super.key, required this.order, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final bool isInTransit = order.status == OrderStatus.inTransit;
    return Container(
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            isInTransit ? LiveDetailsHeader(order: order) : StandardDetailsHeader(order: order),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  DetailRow(icon: Icons.location_on, title: "From", value: order.pickupLocation),
                  DetailRow(icon: Icons.flag, title: "To", value: order.destination),
                  ItemsList(order: order),
                  const Divider(height: 40),
                  PaymentSummary(order: order),
                  const SizedBox(height: 30),
                  TrackButton(order: order),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class LiveDetailsHeader extends StatelessWidget {
  final OrderModel order;
  const LiveDetailsHeader({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1C1E), Color(0xFF0F1012)],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          _buildHandle(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTitleSection(),
              _buildActionButtons(),
            ],
          ),
          const SizedBox(height: 40),
          const _AnimatedProgressLine(), // The 3D Road
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("IN TRANSIT", style: TextStyle(color: Colors.tealAccent, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
        const SizedBox(height: 4),
        Text(order.title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        _circleIconButton(Icons.message_rounded, () {}),
        const SizedBox(width: 10),
        _circleIconButton(Icons.call, () {}, isPrimary: true),
      ],
    );
  }

  Widget _circleIconButton(IconData icon, VoidCallback onTap, {bool isPrimary = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isPrimary ? Colors.tealAccent : Colors.white.withValues(alpha:0.05),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: isPrimary ? Colors.black : Colors.white70),
      ),
    );
  }

  Widget _buildHandle() => Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(2))));
}

class _AnimatedProgressLine extends StatefulWidget {
  const _AnimatedProgressLine();

  @override
  State<_AnimatedProgressLine> createState() => _AnimatedProgressLineState();
}

class _AnimatedProgressLineState extends State<_AnimatedProgressLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<String> _driverMessages = [
    "I'm coming! 🏍️", "Gimme a minute", "Almost there! 🔥",
    "Traffic is heavy.. 😅", "On my way! 🙌", "Approaching! 📍"
  ];

  String _currentMessage = "";
  bool _showMessage = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 4), vsync: this)..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.addListener(() {
      if (_controller.value > 0.48 && _controller.value < 0.52 && !_showMessage) {
        _triggerRandomMessage();
      }
    });
  }

  void _triggerRandomMessage() async {
    if (!mounted) return;
    setState(() {
      _currentMessage = _driverMessages[Random().nextInt(_driverMessages.length)];
      _showMessage = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _showMessage = false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()..setEntry(3, 2, 0.0015)..rotateX(0.7),
          alignment: Alignment.center,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.centerLeft,
            children: [
              // Road
              Container(
                height: 35,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(8, (i) => Container(width: 12, height: 2, color: Colors.white10)),
                ),
              ),
              // Rider
              LayoutBuilder(builder: (context, constraints) {
                double xOffset = _animation.value * (constraints.maxWidth - 45);
                return Transform.translate(
                  offset: Offset(xOffset, -15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedOpacity(
                        opacity: _showMessage ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 400),
                        child: _buildBubble(),
                      ),
                      const SizedBox(height: 4),
                      _buildBikeIcon(_controller.status == AnimationStatus.reverse),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBubble() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
    child: Text(_currentMessage, style: const TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold)),
  );

  Widget _buildBikeIcon(bool flipped) => Transform.flip(
    flipX: flipped,
    child: Container(
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(color: Colors.tealAccent, shape: BoxShape.circle),
      child: const Icon(Icons.moped_rounded, color: Colors.black, size: 16),
    ),
  );
}
class StandardDetailsHeader extends StatelessWidget {
  final OrderModel order;

  const StandardDetailsHeader({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Modal Drag Handle
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
          const SizedBox(height: 25),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "#${order.id.toUpperCase()}",
                  style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Order details and manifest",
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
          const Divider(height: 40, thickness: 1),
        ],
      ),
    );
  }
}