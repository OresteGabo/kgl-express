import 'package:flutter/material.dart';
import 'package:kgl_express/core/enums/payment_method.dart';
import 'package:kgl_express/core/utils/currency_formatter.dart';
import 'package:marquee/marquee.dart';
import 'package:kgl_express/models/order_model.dart';

class PackageCard extends StatelessWidget {
  final Object item; // Changed from OrderModel to Object
  final VoidCallback onTap;

  const PackageCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final data = _getDisplayData();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start, // Align icon to top
            children: [
              _buildStatusLeading(data),
              const SizedBox(width: 16),
              // Details now takes the rest of the space including the price
              _buildOrderDetails(data),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI Logic Extraction ---
  _CardDisplayData _getDisplayData() {
    if (item is OrderModel) {
      final o = item as OrderModel;
      return _CardDisplayData(
        id: o.id,
        title: o.title,
        subtitle: "To: ${o.destination}",
        icon: o.status.icon,
        accentColor: o.status.color,
        statusLabel: o.status.label,
        price: o.price,
        paymentMethod: o.paymentMethod,
      );
    } else if (item is BusTicketModel) {
      final b = item as BusTicketModel;
      return _CardDisplayData(
        id: b.activityId,
        title: b.operator, //"this is my operator, ahwe and whe -n it is tooo long ot creatd a ",//,
        subtitle: "${b.from} ➔ ${b.to}",
        icon: Icons.directions_bus,
        accentColor: Colors.deepOrange,
        statusLabel: b.isActive ? "UPCOMING" : "COMPLETED",
        // Bus tickets might not need price in history if already paid
        price: null,
      );
    }
    // Fallback for unknown types
    return _CardDisplayData(
      id:"#",
        title: "Unknown", subtitle: "", icon: Icons.help, accentColor: Colors.grey, statusLabel: "");
  }

  // --- Sub-Widgets adapted to use _CardDisplayData ---

  Widget _buildStatusLeading(_CardDisplayData data) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: data.accentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(data.icon, color: data.accentColor, size: 26),
    );
  }

  /// TODO When title is too long, the design crash
  Widget _buildOrderDetails(_CardDisplayData data) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ROW 1: Title and ID
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildMarqueeOrText(
                  data.title,
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                data.id.toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    color: Colors.grey[400]
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // ROW 2: Subtitle and Price Card
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMarqueeOrText(
                      data.subtitle,
                      TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    _buildStatusBadge(data),
                  ],
                ),
              ),

              // Integrated Price Card (takes about 2 rows of height visually)
              if (data.price != null) ...[
                const SizedBox(width: 12),
                _buildPriceBadge(data),
              ],
            ],
          ),
        ],
      ),
    );
  }

// Cleaner Price Badge that sits inside the content
  Widget _buildPriceBadge(_CardDisplayData data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50]?.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (data.paymentMethod != null) ...[
            _buildPaymentDisplay(data.paymentMethod!),
            const SizedBox(width: 8),
          ],
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                CurrencyUtils.formatAmount(data.price ?? 0),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
              ),
              const Text(
                  "RWF",
                  style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold, color: Colors.grey)
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMarqueeOrText(String text, TextStyle style) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 1. Calculate how wide the text actually is in pixels
        final textPainter = TextPainter(
          text: TextSpan(text: text.toUpperCase(), style: style),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout();

        // 2. Check if the text width exceeds the available width of the parent
        final bool isOverflowing = textPainter.width > constraints.maxWidth;

        return SizedBox(
          height: (style.fontSize ?? 14) + 8,
          // Wrap in a Row + Expanded to prevent the "Infinite Width" crash
          child: isOverflowing
              ? Marquee(
            text: text.toUpperCase(),
            style: style,
            blankSpace: 30, // Space before the text repeats
            velocity: 30,
            pauseAfterRound: const Duration(seconds: 2),
            accelerationDuration: const Duration(seconds: 1),
            accelerationCurve: Curves.linear,
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

  Widget _buildPriceTrailing(_CardDisplayData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              if (data.paymentMethod != null) _buildPaymentDisplay(data.paymentMethod!),
              Column(
                children: [
                  Text(
                    CurrencyUtils.formatAmount(data.price ?? 0),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                  const Text("RWF", style: TextStyle(fontSize: 8, color: Colors.grey)),
                ]
              ),
            ]
          ),
          /*child: Column(
            children: [
              if (data.paymentMethod != null) _buildPaymentDisplay(data.paymentMethod!),
              const SizedBox(height: 6),
              Text(
                CurrencyUtils.formatAmount(data.price ?? 0),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
              ),
              const Text("RWF", style: TextStyle(fontSize: 8, color: Colors.grey)),
            ],
          ),*/
        ),
      ],
    );
  }

  Widget _buildStatusBadge(_CardDisplayData data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: data.accentColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        data.statusLabel.toUpperCase(),
        style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w900),
      ),
    );
  }

  // Reuse your existing _buildPaymentDisplay logic...
  Widget _buildPaymentDisplay(PaymentMethod method) {
    if (method.assetPath != null) {
      return Image.asset(method.assetPath!, width: 18, height: 18, errorBuilder: (_, _, _) => Icon(method.icon, size: 18));
    }
    return Icon(method.icon, size: 18, color: Colors.blueGrey);
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