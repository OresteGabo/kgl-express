import 'package:flutter/material.dart';
import 'package:kgl_express/models/bus_route.dart';
import 'package:kgl_express/models/route_config.dart';

class BusBookingScreen extends StatefulWidget {
  const BusBookingScreen({super.key});

  @override
  State<BusBookingScreen> createState() => _BusBookingScreenState();
}

class _BusBookingScreenState extends State<BusBookingScreen> {
  // --- STATE VARIABLES ---
  String? selectedOrigin;
  String? selectedDestination;
  String? selectedTime;
  RouteConfig? selectedConfig;
  final List<TextEditingController> _nameControllers = [TextEditingController()];
  String? selectedCityStation = "Nyabugogo Hub"; // Default

  // Example Hub Location
  final String transportHub = "Nyabugogo";

  // Mock Data for Upcountry
  final BusRoute huyeRoute = BusRoute(
    mainRouteName: "South Line",
    stops: ["Kigali", "Ruhango", "Nyanza", "Huye"],
    priceMatrix: {"Kigali-Ruhango": 2500, "Kigali-Huye": 3500}, // etc
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Transport Hub"),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.location_city), text: "Kigali City"),
              Tab(icon: Icon(Icons.map), text: "Upcountry"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildCityTab(),
            _buildUpcountryTab(),
          ],
        ),
      ),
    );
  }

  // --- TAB 1: KIGALI CITY ---


  Widget _buildCityTab() {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // 1. THE TAP&GO CARD (Your previous code)
        _buildTapGoCard(theme),

        const SizedBox(height: 24),

        // 2. STATION SELECTOR
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("At Station", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            DropdownButton<String>(
              value: selectedCityStation,
              underline: const SizedBox(),
              icon: Icon(Icons.keyboard_arrow_down, color: theme.colorScheme.primary),
              items: ["Nyabugogo Hub", "Remera Park", "Kicukiro Center", "Downtown"]
                  .map((s) => DropdownMenuItem(value: s, child: Text(s, style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 14))))
                  .toList(),
              onChanged: (val) => setState(() => selectedCityStation = val),
            ),
          ],
        ),

        // 3. QUICK STATS (Capacity & Crowding)
        _buildStationIntelligence(theme),

        const SizedBox(height: 16),

        // 4. LIVE BUS FEED
        const Text("Upcoming Departures", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 12),

        _buildEnhancedCityBusTile(
            operator: "KBS",
            route: "102: Kanombe - City Center",
            eta: "2m",
            status: "Boarding",
            platform: "Zone A",
            crowdLevel: 0.8 // 80% full
        ),
        _buildEnhancedCityBusTile(
            operator: "Royal Express",
            route: "301: Kicukiro - Downtown",
            eta: "12m",
            status: "In Transit",
            platform: "Zone C",
            crowdLevel: 0.3 // 30% full
        ),
        _buildEnhancedCityBusTile(
            operator: "RFTC",
            route: "405: Kimironko - Nyabugogo",
            eta: "15m",
            status: "Delayed",
            platform: "Zone B",
            crowdLevel: 1.0 // Full
        ),
      ],
    );
  }

  Widget _buildTapGoCard(ThemeData theme) {
    return Container(
      height: 210,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // 1. Background split (Dark Blue Top, Light Blue Bottom)
            Column(
              children: [
                Expanded(flex: 3, child: Container(color: const Color(0xFF3B5998))),
                Expanded(flex: 1, child: Container(color: const Color(0xFF81D4FA))),
              ],
            ),

            // 2. Intore Dancers Watermark
            Positioned.fill(
              child: Opacity(
                opacity: 0.1, // Subtle enough to not distract from balance
                child: Image.asset(
                  'assets/images/intore.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // 3. The Staircase Painter (Your preferred style)
            Positioned.fill(
              child: CustomPaint(
                painter: StaircasePainter(),
              ),
            ),

            // 4. Interactive Content Layer
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.bar_chart, color: Colors.white, size: 32),
                      const SizedBox(width: 8),
                      const Text("Tap&Go",
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      const Icon(Icons.wifi, color: Colors.white, size: 24),
                    ],
                  ),
                  const SizedBox(height: 20),

                  const Text("Balance", style: TextStyle(color: Colors.white70, fontSize: 14)),
                  Row(
                    children: [
                      const Text("4,500 RWF",
                          style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 12),
                      // THE STATUS TAG
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.amber, width: 0.5),
                        ),
                        child: const Text(
                          "PHYSICAL ONLY",
                          style: TextStyle(color: Colors.amber, fontSize: 8, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const Text("Last Trip: Remera - Nyabugogo (KBS)",
                      style: TextStyle(color: Colors.white60, fontSize: 11)),

                  const Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "811538-0024572-22AA4E2B",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          fontFamily: 'monospace',
                        ),
                      ),
                      // Rwanda Flag Asset Integration
                      Image.asset(
                        'assets/icons/rwanda.png',
                        width: 28,
                        height: 18,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.flag, color: Colors.white, size: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStationIntelligence(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(Icons.people, "Crowded", "High"),
          _buildStatItem(Icons.timer, "Avg. Wait", "8 min"),
          _buildStatItem(Icons.alt_route, "Routes", "14"),
        ],
      ),
    );
  }
  Widget _buildEnhancedCityBusTile({
    required String operator,
    required String route,
    required String eta,
    required String status,
    required String platform,
    required double crowdLevel,
  }) {
    final theme = Theme.of(context);
    Color statusColor = status == "Boarding" ? Colors.green : (status == "Delayed" ? Colors.red : Colors.orange);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Text(operator[0], style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(route, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                          child: Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 8),
                        Text("Platform: $platform", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(eta, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: theme.colorScheme.primary)),
                  const Text("ETA", style: TextStyle(fontSize: 9, color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Crowding Indicator
          Row(
            children: [
              const Icon(Icons.airline_seat_recline_normal, size: 14, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: crowdLevel,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    color: crowdLevel > 0.8 ? Colors.red : theme.colorScheme.primary,
                    minHeight: 4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  // --- TAB 2: UPCOUNTRY (With Linked List Logic) ---
  Widget _buildUpcountryTab() {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text("Book Inter-City", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 16),

        // 1. ROUTE SELECTOR
        Row(
          children: [
            Expanded(
              child: _buildUpcountryDropdown(
                hint: "From",
                value: selectedOrigin,
                items: ["Remera", "Kanombe", "Kicukiro", "Nyabugogo"],
                onChanged: (val) => setState(() => selectedOrigin = val),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(Icons.swap_horiz, color: Colors.grey),
            ),
            Expanded(
              child: _buildUpcountryDropdown(
                hint: "To",
                value: selectedDestination,
                items: ["Huye", "Rubavu", "Musanze", "Rusizi"],
                onChanged: (val) => setState(() => selectedDestination = val),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // LINKED TRIP LOGIC
        if (selectedOrigin != null && selectedDestination != null)
          _buildLinkedRouteSuggestion(selectedOrigin!, selectedDestination!),

        const SizedBox(height: 24),

        // 2. OPERATOR SELECTION
        const Text("Select Operator", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ["Volcano", "Horizon", "Ritco", "Stella", "Omega"].map((op) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  label: Text(op),
                  onSelected: (bool value) {},
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 24),

        // 3. DEPARTURES & LIVE UPDATES
        if (selectedDestination != null) ...[
          const Text("Available Busses", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildTimeChip(BusSchedule(
                  time: "09:00",
                  lastSeenLocation: "Kamonyi",
                  lastUpdated: DateTime.now().subtract(const Duration(minutes: 10))
              )),
              _buildTimeChip(BusSchedule(time: "09:30")),
              _buildTimeChip(BusSchedule(time: "10:00")),
            ],
          ),
        ],

        const SizedBox(height: 32),

        // 4. LUGGAGE ONLY (No Insurance/Seats)
        const Text("Extra Services", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 12),
        _buildAddOnTile(Icons.inventory_2_outlined, "Large Luggage / Cargo", "RWF 500"),

        const SizedBox(height: 24),

        // 5. THE "FIRST COME FIRST SERVED" REMINDER
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  "Note: Seats are unassigned. Arrive 15 mins early to choose your preferred seat.",
                  style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // 6. FINAL FARE & BOOKING
        if (selectedDestination != null && selectedTime != null)
          _buildFareCard(theme),
      ],
    );
  }

  Widget _buildAddOnTile(IconData icon, String title, String price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontSize: 14)),
          const Spacer(),
          Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(width: 8),
          const Icon(Icons.add_circle_outline, size: 20, color: Colors.blue),
        ],
      ),
    );
  }
  Widget _buildFareCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Standard Seat", style: TextStyle(fontSize: 12)),
              Text("RWF 3,500", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Pay", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text("RWF 3,500", style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: theme.colorScheme.primary
              )),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Confirm & Pay"),
            ),
          )
        ],
      ),
    );
  }
  Widget _buildUpcountryDropdown({required String hint, String? value, required List<String> items, required Function(String?) onChanged}) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        filled: true,
        fillColor: Colors.grey.withValues(alpha: 0.1),
      ),
      hint: Text(hint, style: const TextStyle(fontSize: 13)),
      value: value,
      items: items.map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 13)))).toList(),
      onChanged: onChanged,
    );
  }

  // --- SUPPORTING UI WIDGETS ---

  Widget _buildTimeChip(BusSchedule schedule) {
    final theme = Theme.of(context);
    bool hasLiveInfo = schedule.lastSeenLocation != null;
    bool isSelected = selectedTime == schedule.time;

    return Column(
      children: [
        ChoiceChip(
          label: Text(schedule.time),
          selected: isSelected,
          onSelected: (val) => setState(() => selectedTime = val ? schedule.time : null),
          selectedColor: theme.colorScheme.primary,
        ),
        if (hasLiveInfo)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on, size: 10, color: Colors.green),
                Text(
                  " ${schedule.lastSeenLocation} (${_timeAgo(schedule.lastUpdated)})",
                  style: const TextStyle(fontSize: 8, color: Colors.green),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // Your logic from the previous prompt
  Widget _buildLinkedRouteSuggestion(String start, String end) {
    bool needsHub = start != transportHub && _isUpcountry(end);
    if (!needsHub) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Text(
        "💡 Link Found: Take city bus from $start to $transportHub to catch the $end bus.",
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }

  String _timeAgo(DateTime? time) {
    if (time == null) return "";
    final diff = DateTime.now().difference(time);
    return "${diff.inMinutes}m ago";
  }

  bool _isUpcountry(String destination) => ["Huye", "Rubavu", "Musanze"].contains(destination);
}

class StaircasePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0;

    final path = Path();

    // Starting the staircase from the middle-right area
    // Adjusting these coordinates to create the "bump" or "step"
    path.moveTo(size.width * 0.5, size.height);
    path.lineTo(size.width * 0.65, size.height * 0.75); // First step up
    path.lineTo(size.width * 0.85, size.height * 0.75); // Flat section
    path.lineTo(size.width, size.height * 0.55);      // Final exit

    canvas.drawPath(path, paint);

    // Draw a second thinner line below it for the "double line" look
    paint.strokeWidth = 3.0;
    paint.color = Colors.white.withValues(alpha: 0.4);

    final path2 = Path();
    path2.moveTo(size.width * 0.4, size.height);
    path2.lineTo(size.width * 0.55, size.height * 0.82);
    path2.lineTo(size.width * 0.85, size.height * 0.82);
    path2.lineTo(size.width, size.height * 0.65);

    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
