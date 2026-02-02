import 'package:flutter/material.dart';
import 'package:kgl_express/core/enums/payment_method.dart';
import 'package:kgl_express/core/utils/currency_formatter.dart';
import 'package:marquee/marquee.dart';
import 'package:kgl_express/models/order_model.dart';

class PackageCard extends StatelessWidget {
  final Object item;
  final VoidCallback onTap;

  const PackageCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = _getDisplayData(context); // Pass context to map colors semantically

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      // Using surfaceContainer as the card base for M3 consistency
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusLeading(context, data),
              const SizedBox(width: 16),
              _buildOrderDetails(context, data),
            ],
          ),
        ),
      ),
    );
  }

  _CardDisplayData _getDisplayData(BuildContext context) {
    final theme = Theme.of(context);

    if (item is OrderModel) {
      final o = item as OrderModel;
      return _CardDisplayData(
        id: o.id,
        title: o.title,
        subtitle: "To: ${o.destination}",
        icon: o.status.icon,
        // We assume OrderStatus.color might still be hardcoded,
        // ideally these should map to theme.colorScheme.primary/tertiary/error
        accentColor: o.status.color,
        statusLabel: o.status.label,
        price: o.price,
        paymentMethod: o.paymentMethod,
      );
    } else if (item is BusTicketModel) {
      final b = item as BusTicketModel;
      return _CardDisplayData(
        id: b.activityId,
        title: b.operator,
        subtitle: "${b.from} ➔ ${b.to}",
        icon: Icons.directions_bus,
        // Semantic Mapping: Bus tickets use Tertiary (Green/Teal) or Primary
        accentColor: theme.colorScheme.tertiary,
        statusLabel: b.isActive ? "UPCOMING" : "COMPLETED",
        price: null,
      );
    }

    return _CardDisplayData(
      id: "#",
      title: "Unknown",
      subtitle: "",
      icon: Icons.help,
      accentColor: theme.colorScheme.outline,
      statusLabel: "UNKNOWN",
    );
  }

  Widget _buildStatusLeading(BuildContext context, _CardDisplayData data) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: data.accentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(data.icon, color: data.accentColor, size: 26),
    );
  }

  Widget _buildOrderDetails(BuildContext context, _CardDisplayData data) {
    final theme = Theme.of(context);

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildMarqueeOrText(
                  context,
                  data.title,
                  theme.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                data.id.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMarqueeOrText(
                      context,
                      data.subtitle,
                      theme.textTheme.bodySmall!.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 8),
                    _buildStatusBadge(context, data),
                  ],
                ),
              ),
              if (data.price != null) ...[
                const SizedBox(width: 12),
                _buildPriceBadge(context, data),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBadge(BuildContext context, _CardDisplayData data) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (data.paymentMethod != null) ...[
            _buildPaymentDisplay(context, data.paymentMethod!),
            const SizedBox(width: 6),
          ],
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                CurrencyUtils.formatAmount(data.price ?? 0),
                style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              Text(
                "RWF",
                style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.outline
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMarqueeOrText(BuildContext context, String text, TextStyle style) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
          text: TextSpan(text: text.toUpperCase(), style: style),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout();

        final bool isOverflowing = textPainter.width > constraints.maxWidth;

        return SizedBox(
          height: (style.fontSize ?? 14) + 6,
          child: isOverflowing
              ? Marquee(
            text: text.toUpperCase(),
            style: style,
            blankSpace: 30,
            velocity: 30,
            pauseAfterRound: const Duration(seconds: 2),
          )
              : Text(
            text.toUpperCase(),
            style: style,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(BuildContext context, _CardDisplayData data) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: data.accentColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        data.statusLabel.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onPrimary, // Contrast logic: usually primary icons use onPrimary
          fontSize: 8,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildPaymentDisplay(BuildContext context, PaymentMethod method) {
    final theme = Theme.of(context);
    if (method.assetPath != null) {
      return Image.asset(
          method.assetPath!,
          width: 16,
          height: 16,
          errorBuilder: (_, _, _) => Icon(method.icon, size: 16, color: theme.colorScheme.onSurfaceVariant)
      );
    }
    return Icon(method.icon, size: 16, color: theme.colorScheme.onSurfaceVariant);
  }
}

// Helper class to standardize data for the Card
class _CardDisplayData {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final String statusLabel;
  final double? price;
  final PaymentMethod? paymentMethod;

  _CardDisplayData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.statusLabel,
    this.price,
    this.paymentMethod,
  });
}