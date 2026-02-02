import 'package:flutter/material.dart';
/*
class LiveDeliveryBar extends StatelessWidget {
  final String from;
  final String to;

  const LiveDeliveryBar({super.key, required this.from, required this.to});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black, // Dark high-contrast look
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _locationText(from),
              const Icon(Icons.moped, color: Colors.white, size: 16),
              _locationText(to),
            ],
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              // The Dashed Line Background
              Row(
                children: List.generate(
                  20,
                      (index) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      height: 2,
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                ),
              ),
              // The Moving Dot/Moto
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(seconds: 4),
                curve: Curves.easeInOut,
                builder: (context, value, child) {
                  return Align(
                    alignment: Alignment(value * 2 - 1, 0), // Moves from -1 to 1
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.redAccent, blurRadius: 10, spreadRadius: 2)
                        ],
                      ),
                    ),
                  );
                },
                onEnd: () {}, // You can loop it later if you want
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _locationText(String text) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
    );
  }
}*/