import 'package:flutter/material.dart';

class QuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isActivated; // New boolean to control state

  const QuickActionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    this.isActivated = true, // Default to true
  });

  @override
  Widget build(BuildContext context) {
    // Determine active colors vs deactivated (grayscale) colors
    final displayColor = isActivated ? color : Colors.grey;
    final backgroundColor = isActivated
        ? color.withValues(alpha: 0.08)
        : Colors.grey.withValues(alpha: 0.05);

    return GestureDetector(
      // Only trigger navigation if the service is activated
      onTap: isActivated ? onTap : () {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("This service is coming soon to KGL Express!"))
        );
      },
      child: Stack(
        children: [
          Container(
            width: 105,
            margin: const EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: displayColor.withValues(alpha: 0.2),
                  width: 1
              ),
            ),
            child: Opacity(
              opacity: isActivated ? 1.0 : 0.6, // Dim the icon/text if inactive
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: displayColor.withValues(alpha: 0.2),
                    child: Icon(icon, color: displayColor, size: 22),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: displayColor.withValues(alpha: 0.8),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Small "Coming Soon" badge for deactivated services
          if (!isActivated)
            Positioned(
              top: 8,
              right: 22,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "SOON",
                  style: TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }
}