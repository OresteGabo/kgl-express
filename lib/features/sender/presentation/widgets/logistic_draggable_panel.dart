import 'package:flutter/material.dart';
import 'package:kgl_express/core/constants/mock_data.dart';
import 'package:kgl_express/core/enums/order_status.dart';
import 'package:kgl_express/core/presentation/ui_factory/platform_ui.dart';
import 'package:kgl_express/features/sender/presentation/widgets/detail_row.dart';
import 'package:kgl_express/features/sender/presentation/widgets/package_card.dart';
import 'package:kgl_express/features/sender/presentation/widgets/payment_summary.dart';
import 'package:kgl_express/features/sender/presentation/widgets/quick_actions_grid.dart';
import 'package:kgl_express/models/order_model.dart';
import 'package:marquee/marquee.dart';
import 'package:path/path.dart';

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
    final theme = Theme.of(context);
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
              color: theme.colorScheme.surfaceContainerLow, // Matches #F8F9FA in light, darkens in dark
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.08),
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
                itemCount: mockOrders.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) return _buildHeaderSection(context, liveActivities);
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
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 24),

        if (liveActivities.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Live Tracking",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
              if (liveActivities.length > 1)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${liveActivities.length} ACTIVE",
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onTertiaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
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
        Text(
          "Recent Activity",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            color: theme.colorScheme.onSurface,
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
    final theme = Theme.of(context);
    final bool isInTransit = order.status == OrderStatus.inTransit;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      // Logistics Info components usually use theme internally
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
                      Divider(height: 40, color: theme.colorScheme.outlineVariant),
                      PaymentSummary(order: order),
                      const SizedBox(height: 30),
                      AppUI.factory.buildButton(
                        context: context,
                        onPressed: () => Navigator.pop(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(isInTransit ? Icons.map : Icons.arrow_back,
                                color: theme.colorScheme.onPrimary),
                            const SizedBox(width: 12),
                            Text(
                              isInTransit ? "Open Live Map" : "Close Details",
                              style: TextStyle(
                                  color: theme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold
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
        ),
      ),
    );
  }

  // Refactored Ticket Details Section
  void _showTicketDetails(BuildContext context, BusTicketModel ticket) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Stack(
                children: [
                  ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                    children: [
                      _buildTicketHeader(context, ticket),
                      const SizedBox(height: 30),
                      _buildRouteSection(context, ticket),
                      const SizedBox(height: 30),
                      _buildTicketMainBody(context, ticket),
                      SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
                    ],
                  ),
                  Positioned(
                    top: 12,
                    left: 0,
                    right: 0,
                    child: Center(child: _buildDragHandle(context)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

// 1. HELPER: Drag Handle
  Widget _buildDragHandle(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  // 2. HELPER: Operator & Logo
  Widget _buildTicketHeader(BuildContext context, BusTicketModel ticket) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1. VEHICLE IDENTITY BLOCK
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60, // Slightly larger for better presence
              height: 60,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(18),
                // Subtle inner shadow effect for depth
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: ticket.operatorLogo != null
                  ? Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(ticket.operatorLogo!, fit: BoxFit.contain),
              )
                  : Icon(
                Icons.directions_bus_rounded,
                color: theme.colorScheme.onPrimaryContainer,
                size: 34,
              ),
            ),
            const SizedBox(height: 8),

            // REALISTIC LICENSE PLATE
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
              child: Text(
                ticket.carPlate.toUpperCase(),
                style: TextStyle(
                  fontFamily: 'monospace', // Gives it the "stamped" vehicle look
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.onSurface,
                  fontSize: 10,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 18),

        // 2. OPERATOR INFO
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ticket.operator,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.8,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "ID: ${ticket.activityId}",
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),

        // 3. ACTION BUTTON (QR)
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.qr_code_2_rounded, // More "ticket-like" icon
              color: theme.colorScheme.primary,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }

// 3. HELPER: The Route Section (Now using Column to avoid overflow)
  Widget _buildRouteSection(BuildContext context, BusTicketModel ticket) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Column(
          children: [
            Icon(Icons.radio_button_unchecked, size: 16, color: theme.colorScheme.outline),
            Container(
              width: 2,
              height: 40,
              color: theme.colorScheme.outlineVariant,
            ),
            Icon(Icons.location_on, size: 18, color: theme.colorScheme.primary),
          ],
        ),
        const SizedBox(width: 20),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TicketStation(city: ticket.from, label: "Origin"),
              const SizedBox(height: 12),
              _TicketStation(city: ticket.to, label: "Destination"),
            ],
          ),
        ),
      ],
    );
  }

// 4. HELPER: Main Ticket Card
  Widget _buildTicketMainBody(BuildContext context, BusTicketModel ticket) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          _buildStatusBanner(context, "Operator: Bus has arrived at Nyabugogo. You can now board."),
          const SizedBox(height: 24),
          _InfoBlock(label: "PASSENGER", value: ticket.passengerName),
          Divider(height: 32, color: theme.colorScheme.outlineVariant),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _InfoBlock(label: "CAR PLATE", value: ticket.carPlate, isHighlight: true),
              _buildPaymentChip(context, ticket),
            ],
          ),
          Divider(height: 32, color: theme.colorScheme.outlineVariant),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _InfoBlock(label: "DEPARTURE DATE", value: "Feb 12, 2026"),
              _InfoBlock(label: "TIME", value: "09:30 AM"),
            ],
          ),

          const SizedBox(height: 40),

          // QR/Data Matrix Section
          // QR/Data Matrix Section
          Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
              AppUI.factory.buildWalletButton(
                context: context,
                onPressed: () => AppUI.factory.handleWalletAddition(
                  passUrl: "https://api.kglexpress.com/passes/123",
                  data: {
                    "jwt": "your-google-wallet-signed-token",
                  },
                ),
              ),
                const SizedBox(height: 12),
                // The factory now decides which text AND style to show
                AppUI.factory.buildWalletInstructionText(),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Helper for the Success Payment Chip
  Widget _buildPaymentChip(BuildContext context, BusTicketModel ticket) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text("PAYMENT STATUS", style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outline)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: theme.colorScheme.tertiaryContainer),
          ),
          child: Row(
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
              Text(
                ticket.paymentMethod.label.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onTertiaryContainer,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.check_circle, color: theme.colorScheme.tertiary, size: 14),
            ],
          ),
        ),
      ],
    );
  }
// 5. SMALL HELPERS for reusable UI components
  Widget _buildStatusBanner(BuildContext context, String message) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.primaryContainer),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: theme.colorScheme.primary, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message,
                style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold
                )),
          ),
        ],
      ),
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
    final theme = Theme.of(context);

    // Define the style based on the theme's text and surface colors
    final textStyle = theme.textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w900,
      color: theme.colorScheme.onSurface,
    ) ?? const TextStyle();

    return Column(
      crossAxisAlignment: align,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.outline,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 4),

        LayoutBuilder(
          builder: (context, constraints) {
            final String upperCity = city.toUpperCase();
            final textPainter = TextPainter(
              text: TextSpan(text: upperCity, style: textStyle),
              maxLines: 1,
              textDirection: TextDirection.ltr,
            )..layout();

            if (textPainter.width > constraints.maxWidth) {
              return SizedBox(
                height: 28,
                child: Marquee(
                  text: upperCity,
                  style: textStyle,
                  scrollAxis: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  blankSpace: 40.0,
                  velocity: 30.0,
                  pauseAfterRound: const Duration(seconds: 2),
                ),
              );
            }

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
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
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
    final theme = Theme.of(context);

    // Use primary for highlights (the Gold/Orange) and onSurface for standard
    final valueStyle = theme.textTheme.bodyLarge?.copyWith(
      fontWeight: FontWeight.w800,
      color: isHighlight ? theme.colorScheme.primary : theme.colorScheme.onSurface,
    ) ?? const TextStyle();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.outline,
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
            style: valueStyle,
            blankSpace: 20,
            velocity: 30,
            pauseAfterRound: const Duration(seconds: 2),
          )
              : Text(
            value.toUpperCase(),
            maxLines: 1,
            style: valueStyle,
          ),
        ),
      ],
    );
  }
}
