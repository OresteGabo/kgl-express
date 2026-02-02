import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kgl_express/core/enums/order_status.dart';
import 'package:kgl_express/core/presentation/ui_factory/platform_ui.dart';
import 'package:kgl_express/features/sender/presentation/widgets/detail_row.dart';
import 'package:kgl_express/models/order_model.dart';

import 'package:kgl_express/features/sender/presentation/widgets/items_list.dart';
import 'package:kgl_express/features/sender/presentation/widgets/payment_summary.dart';

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
    final theme = Theme.of(context);
    final bool isInTransit = order.status == OrderStatus.inTransit;

    return Container(
      decoration: BoxDecoration(
        // Use surface color for the bottom half of the sheet
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30))
      ),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            isInTransit ? LiveDetailsHeader(order: order) : StandardDetailsHeader(order: order),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // These sub-widgets should internally use theme.colorScheme.onSurface
                  DetailRow(icon: Icons.location_on, title: "From", value: order.pickupLocation),
                  DetailRow(icon: Icons.flag, title: "To", value: order.destination),
                  ItemsList(order: order),
                  const Divider(height: 40),
                  PaymentSummary(order: order),
                  const SizedBox(height: 30),
                  AppUI.factory.buildButton(
                    context: context,
                    onPressed: () {
                      if (order.status == OrderStatus.inTransit) {
                        // Handle Map
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    backgroundColor: order.status == OrderStatus.inTransit
                        ? theme.colorScheme.tertiary
                        : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          order.status == OrderStatus.inTransit ? Icons.map : Icons.arrow_back,
                          color: theme.colorScheme.onTertiary, // Ensure contrast
                        ),
                        const SizedBox(width: 10),
                        Text(
                          order.status == OrderStatus.inTransit ? "Open Live Map" : "Close Details",
                          style: TextStyle(
                            color: theme.colorScheme.onTertiary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
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
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 30),
      decoration: BoxDecoration(
        // Stays dark even in light mode
        color: theme.colorScheme.inverseSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          _buildHandle(theme),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTitleSection(theme),
              _buildActionButtons(theme),
            ],
          ),
          const SizedBox(height: 40),
          const _AnimatedProgressLine(),
        ],
      ),
    );
  }
  Widget _buildTitleSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "IN TRANSIT",
          style: TextStyle(
            color: theme.colorScheme.tertiaryContainer,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.4,
            shadows: [
              Shadow(
                blurRadius: 4.0,
                color: theme.colorScheme.shadow.withValues(alpha: 0.5),
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          order.title,
          style: TextStyle(
            color: theme.colorScheme.onInverseSurface,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _circleIconButton(ThemeData theme, IconData icon, VoidCallback onTap, {bool isPrimary = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isPrimary
              ? theme.colorScheme.primary // Use brand gold/green
              : theme.colorScheme.onInverseSurface.withValues(alpha: 0.1), // Subtle gray
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18,
          // Logic: Primary button gets dark icon, subtle button gets light icon
          color: isPrimary
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.onInverseSurface,
        ),
      ),
    );
  }
  Widget _buildHandle(ThemeData theme) => Center(
      child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
              color: theme.colorScheme.onInverseSurface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2)
          )
      )
  );
  Widget _buildActionButtons(ThemeData theme) {
    return Row(
      children: [
        // Message button: Subtle light-on-dark look
        _circleIconButton(
            theme,
            Icons.message_rounded,
                () {},
            isPrimary: false
        ),
        const SizedBox(width: 10),
        // Call button: High emphasis brand look
        _circleIconButton(
            theme,
            Icons.call,
                () {},
            isPrimary: true
        ),
      ],
    );
  }

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
    final theme = Theme.of(context);
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
              // Inside the Road Container
              Container(
                height: 35,
                width: double.infinity,
                decoration: BoxDecoration(
                  // A subtle hint of the foreground color on the dark background
                  color: theme.colorScheme.onInverseSurface.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    8,
                        (i) => Container(
                      width: 12,
                      height: 2,
                      // The dashed lines now adapt to the theme's text/icon color
                      color: theme.colorScheme.onInverseSurface.withValues(alpha: 0.1),
                    ),
                  ),
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
                        child: _buildBubble(theme),
                      ),
                      const SizedBox(height: 4),
                      _buildBikeIcon(theme,_controller.status == AnimationStatus.reverse),
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

  Widget _buildBubble(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        // inverseSurface ensures the bubble is light-colored
        // even if the rest of the app is in Dark Mode
        color: theme.colorScheme.inverseSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _currentMessage,
        style: TextStyle(
          // onInverseSurface will be the dark text color for that bubble
          color: theme.colorScheme.onInverseSurface,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBikeIcon(ThemeData theme, bool flipped) {
    return Transform.flip(
      flipX: flipped,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary, // Your Brand Gold/Green
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.4),
              blurRadius: 8,
              spreadRadius: 1,
            )
          ],
        ),
        child: Icon(
          Icons.moped_rounded,
          color: theme.colorScheme.onPrimary, // High contrast icon color
          size: 16,
        ),
      ),
    );
  }
}
class StandardDetailsHeader extends StatelessWidget {
  final OrderModel order;

  const StandardDetailsHeader({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
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
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "#${order.id.toUpperCase()}",
                  style: TextStyle(
                    color: theme.colorScheme.primary,
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
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 14),
          ),
          Divider(height: 40, thickness: 1, color: theme.colorScheme.outlineVariant),
        ],
      ),
    );
  }
}