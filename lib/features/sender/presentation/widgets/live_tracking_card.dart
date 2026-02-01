import 'package:flutter/material.dart';
import 'package:kgl_express/models/order_model.dart';
import 'dart:math';

// Import your existing sheet function or define it locally if not accessible
import 'package:kgl_express/features/sender/presentation/widgets/order_details_sheet.dart';
/*
class LiveTrackingCard extends StatelessWidget {
  final OrderModel order;

  const LiveTrackingCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Material( // 1. Added Material for the tap ripple effect
      color: Colors.transparent,
      child: InkWell( // 2. InkWell makes the whole card clickable
        onTap: () => showOrderDetailsSheet(context, order),
        borderRadius: BorderRadius.circular(28),
        splashColor: Colors.tealAccent.withValues(alpha:0.1),
        highlightColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1A1C1E),
                Color(0xFF0F1012),
              ],
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha:0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Row: Locations
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LocationInfo(
                      location: order.pickupLocation,
                      label: "PICKUP",
                      alignment: CrossAxisAlignment.start
                  ),
                  _buildCenterIcon(),
                  _LocationInfo(
                      location: order.destination,
                      label: "DESTINATION",
                      alignment: CrossAxisAlignment.end
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Bottom Section: Progress Animation
              const _AnimatedProgressLine(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenterIcon() {
    return Column(
      children: [
        const Icon(Icons.moped_rounded, color: Colors.tealAccent, size: 22),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            order.id.toUpperCase(),
            style: const TextStyle(
                color: Colors.white30,
                fontSize: 8,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ],
    );
  }
}
*/
/*
class _LocationInfo extends StatelessWidget {
  final String location;
  final String label;
  final CrossAxisAlignment alignment;

  const _LocationInfo({required this.location, required this.label, required this.alignment});

  @override
  Widget build(BuildContext context) {
    return Expanded( // Added Expanded to handle long Kigali addresses
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white38,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            location,
            textAlign: alignment == CrossAxisAlignment.end ? TextAlign.right : TextAlign.left,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
*/

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
    "Traffic is heavy.. 😅", "On my way! 🙌", "Approaching! 📍", "Nearly there 🏁"
  ];

  String _currentMessage = "";
  bool _showMessage = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Monitor the bike's position to trigger random messages
    _controller.addListener(() {
      // Trigger a message when bike is near the middle (0.5)
      // and we aren't already showing one
      if (_controller.value > 0.45 && _controller.value < 0.55 && !_showMessage) {
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

    // Keep message visible for 2 seconds, then hide
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _showMessage = false;
      });
    }
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
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0015)
            ..rotateX(0.7),
          alignment: Alignment.center,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.centerLeft,
            children: [
              // 1. The Road
              Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha:0.04),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(10, (index) => Container(
                    width: 12, height: 2, color: Colors.white.withValues(alpha:0.1),
                  )),
                ),
              ),

              // 2. Bike + Fading Tooltip
              LayoutBuilder(
                builder: (context, constraints) {
                  double xOffset = _animation.value * (constraints.maxWidth - 45);
                  bool isGoingLeft = _controller.status == AnimationStatus.reverse;

                  return Transform.translate(
                    offset: Offset(xOffset, -15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // --- THE FADING TOOLTIP ---
                        AnimatedOpacity(
                          opacity: _showMessage ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 500),
                          child: _buildSpeechBubble(_currentMessage),
                        ),
                        const SizedBox(height: 8),

                        // --- THE BIKE ---
                        Transform.flip(
                          flipX: isGoingLeft,
                          child: _buildBikeIcon(),
                        ),

                        // --- THE SHADOW ---
                        Container(
                          width: 16, height: 3,
                          margin: const EdgeInsets.only(top: 8),
                          decoration: BoxDecoration(
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.4), blurRadius: 4)],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBikeIcon() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.tealAccent,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.tealAccent.withValues(alpha:0.4),
            blurRadius: 12,
            spreadRadius: 2,
          )
        ],
      ),
      child: const Icon(Icons.moped_rounded, color: Color(0xFF0F1012), size: 18),
    );
  }

  Widget _buildSpeechBubble(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha:0.95),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF1A1C1E),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

//import 'package:flutter/material.dart';



// --- SHARED BASE DESIGN ---
class _BaseLiveCard extends StatelessWidget {
  final Widget child;
  const _BaseLiveCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1C1E), Color(0xFF0F1012)],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: child,
    );
  }
}



// Shared Sub-Widget
class _LocationColumn extends StatelessWidget {
  final String label, value;
  final CrossAxisAlignment crossAxis;
  const _LocationColumn({required this.label, required this.value, required this.crossAxis});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: crossAxis,
        children: [
          Text(label, style: const TextStyle(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 13)),
        ],
      ),
    );
  }
}

// Reuse your _AnimatedRoadIcon logic from the previous snippet here...

/**
 * NEW CODE USING A DESIGN PATTERN FACTORY:
 * */

// --- 1. THE MODELS (Mocking your models for the file) ---

enum ActivityType { delivery, bus, rental }

abstract class LiveActivityModel {
  final String id;
  final ActivityType type;
  LiveActivityModel({required this.id, required this.type});
}
/*
class OrderModel extends LiveActivityModel {
  final String pickupLocation;
  final String destination;
  OrderModel({required super.id, required this.pickupLocation, required this.destination})
      : super(type: ActivityType.delivery);
}*/
/*
class BusTicketModel extends LiveActivityModel {
  final String from;
  final String to;
  final String seatNumber;
  final DateTime departureTime;
  final String operatorName;

  BusTicketModel({
    required super.id,
    required this.from,
    required this.to,
    required this.seatNumber,
    required this.departureTime,
    required this.operatorName,
  }) : super(type: ActivityType.bus);
}
*/
// --- 2. THE FACTORY ---

class LiveActivityFactory {
  static Widget createCard(Object activity, BuildContext context) {
    if (activity is OrderModel) {
      return DeliveryLiveCard(order: activity);
    } else if (activity is BusTicketModel) {
      return BusLiveCard(ticket: activity);
    }
    return const SizedBox.shrink();
  }
}

// --- 3. THE BASE WRAPPER (Common Design) ---

class BaseLiveCard extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const BaseLiveCard({super.key, required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1C1E), Color(0xFF0F1012)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          splashColor: Colors.tealAccent.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: child,
          ),
        ),
      ),
    );
  }
}

// --- 4. CONCRETE IMPLEMENTATION: DELIVERY ---

class DeliveryLiveCard extends StatelessWidget {
  final OrderModel order;
  const DeliveryLiveCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return _BaseLiveCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _LocationColumn(label: "PICKUP", value: order.pickupLocation, crossAxis: CrossAxisAlignment.start),
              Icon(Icons.moped, color: Colors.tealAccent, size: 20),
              _LocationColumn(label: "DESTINATION", value: order.destination, crossAxis: CrossAxisAlignment.end),
            ],
          ),
          const SizedBox(height: 20),
          ///TODO
          _AnimatedRoadIcon(), // Your cool animation logic here
        ],
      ),
    );
  }
}

// --- 5. CONCRETE IMPLEMENTATION: BUS TICKET ---

class BusLiveCard extends StatelessWidget {
  final BusTicketModel ticket;
  const BusLiveCard({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return _BaseLiveCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _LocationColumn(label: "FROM", value: ticket.from, crossAxis: CrossAxisAlignment.start),
              _LocationColumn(label: "OPERATOR", value: ticket.operator, crossAxis: CrossAxisAlignment.center),
              _LocationColumn(label: "TO", value: ticket.to, crossAxis: CrossAxisAlignment.end),
            ],
          ),
          const Divider(color: Colors.white10, height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Seat: ${ticket.seat}", style: TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
              Text("Status: Boarding", style: TextStyle(color: Colors.orangeAccent)),
            ],
          )
        ],
      ),
    );
  }
}

// --- SHARED UI SUB-COMPONENTS ---

class _LocationInfo extends StatelessWidget {
  final String location, label;
  final CrossAxisAlignment alignment;
  const _LocationInfo({required this.location, required this.label, required this.alignment});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
          const SizedBox(height: 6),
          Text(location, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _CenterIcon extends StatelessWidget {
  final IconData icon;
  final String id;
  const _CenterIcon({required this.icon, required this.id});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.tealAccent, size: 22),
        const SizedBox(height: 4),
        Text(id.toUpperCase(), style: const TextStyle(color: Colors.white30, fontSize: 8, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _InfoColumn extends StatelessWidget {
  final String label, value;
  final bool isHighlight;
  final Color? color;
  const _InfoColumn({required this.label, required this.value, this.isHighlight = false, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color ?? (isHighlight ? Colors.tealAccent : Colors.white), fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// --- THE ANIMATED ROAD (REUSED FOR DELIVERY) ---

class _AnimatedRoad extends StatefulWidget {
  final IconData icon;
  const _AnimatedRoad({required this.icon});

  @override
  State<_AnimatedRoad> createState() => _AnimatedRoadState();
}

class _AnimatedRoadState extends State<_AnimatedRoad> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 3), vsync: this)..repeat(reverse: true);
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(height: 4, width: double.infinity, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(2))),
            Positioned(
              left: _controller.value * (MediaQuery.of(context).size.width - 100),
              child: Icon(widget.icon, color: Colors.tealAccent, size: 20),
            ),
          ],
        );
      },
    );
  }
}

class _AnimatedRoadIcon extends StatefulWidget {
  const _AnimatedRoadIcon();

  @override
  State<_AnimatedRoadIcon> createState() => _AnimatedRoadIconState();
}

class _AnimatedRoadIconState extends State<_AnimatedRoadIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
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
        return Column(
          children: [
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                // The Road (Dashed Line)
                Container(
                  height: 2,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      15,
                          (index) => Container(
                        width: 10,
                        height: 2,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                ),
                // The Moving Bike
                LayoutBuilder(
                  builder: (context, constraints) {
                    double maxWidth = constraints.maxWidth - 30;
                    return Transform.translate(
                      offset: Offset(_animation.value * maxWidth, -10),
                      child: Transform.flip(
                        flipX: _controller.status == AnimationStatus.reverse,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.tealAccent,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.tealAccent.withValues(alpha: 0.4),
                                blurRadius: 8,
                                spreadRadius: 1,
                              )
                            ],
                          ),
                          child: const Icon(
                            Icons.moped_rounded,
                            color: Color(0xFF0F1012),
                            size: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              _controller.status == AnimationStatus.reverse
                  ? "Returning to warehouse..."
                  : "On the way to destination...",
              style: const TextStyle(color: Colors.white24, fontSize: 10, fontStyle: FontStyle.italic),
            )
          ],
        );
      },
    );
  }
}