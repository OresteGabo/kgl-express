import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kgl_express/core/constants/mock_data.dart';
import 'package:kgl_express/core/presentation/ui_factory/platform_ui.dart';
import 'package:kgl_express/features/sender/presentation/ProviderProfileScreen.dart';
import 'package:kgl_express/features/sender/presentation/ServiceProvidersListScreen.dart';
import 'package:kgl_express/features/sender/presentation/widgets/provider_tile.dart..dart';
import 'package:flutter/widget_previews.dart';

@Preview(name: 'Service Selection Screen')
Widget previewServiceSelection() {
  return const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ServiceSelectionScreen(),
  );
}

@Preview(name: 'Wiggling Button Alone')
Widget previewWiggle() {
  return Center(
    child: SizedBox(
      width: 100,
      height: 100,
      child: WigglingCustomizeButton(onTap: () {}),
    ),
  );
}

class ServiceSelectionScreen extends StatefulWidget {
  const ServiceSelectionScreen({super.key});

  @override
  State<ServiceSelectionScreen> createState() => _ServiceSelectionScreenState();
}

class _ServiceSelectionScreenState extends State<ServiceSelectionScreen> {
  // Renamed variables for clarity
  List<int> _selectedServiceIds = [0, 1, 2, 3, 4];
  final int maxPinnedServices = 8;
  final int minPinnedServices = 2;

  // Inside _ServiceSelectionScreenState, add a controller
  final TextEditingController _searchController = TextEditingController();

// Add this helper method to build the Search Bar
  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Search for services (e.g. Plumber, Food...)",
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
          // Monetization hint: You could add a "Voice Search" icon here
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => setState(() => _searchController.clear())
          )
              : null,
        ),
        onSubmitted: (value) {
          // Logic to jump to the first matching service
          _handleSearch(value);
        },
      ),
    );
  }

  void _handleSearch(String query) {
    if (query.isEmpty) return;

    // Find matching service in our master list
    try {
      final match = rwandaServices.firstWhere(
              (s) => s.name.toLowerCase().contains(query.toLowerCase())
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ServiceProvidersListScreen(service: match)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No service found with that name."))
      );
    }
  }
  void _showServicePicker() {
    List<int> tempSelected = List.from(_selectedServiceIds);
    String searchQuery = ""; // Local state for filtering


    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        final ui = AppUI.factory;
        return StatefulBuilder(
          builder: (context, setModalState) {
            // Filter the master list based on search
            final filteredServices = rwandaServices.where((s) {
              return s.name.toLowerCase().contains(searchQuery.toLowerCase());
            }).toList();

            return Container(
              padding: const EdgeInsets.all(24),
              height: MediaQuery.of(context).size.height * 0.8, // Slightly taller for search
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Customize your Grid",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),

                  // 1. Search Bar inside the Modal
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: "Search services...",
                        prefixIcon: Icon(Icons.search, size: 20),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      onChanged: (value) {
                        setModalState(() => searchQuery = value);
                      },
                    ),
                  ),
                  const SizedBox(height: 15),

                  // 2. The Filtered List
                  Expanded(
                    child: filteredServices.isEmpty
                        ? const Center(child: Text("No services found."))
                        : ListView.builder(
                      itemCount: filteredServices.length,
                      itemBuilder: (context, index) {
                        final service = filteredServices[index];
                        // We must find the original index in the master list
                        // to keep the _selectedServiceIds accurate
                        final originalIndex = rwandaServices.indexOf(service);
                        final isSelected = tempSelected.contains(originalIndex);

                        return ui.buildSelectionTile(
                          title: service.name,
                          icon: service.icon,
                          iconColor: service.color,
                          isSelected: isSelected,
                          onChanged: (bool? value) {
                            setModalState(() {
                              if (value == true) {
                                if (tempSelected.length < maxPinnedServices) {
                                  tempSelected.add(originalIndex);
                                } else {
                                  _showLimitReachedSnack();
                                }
                              } else {
                                if (tempSelected.length > minPinnedServices) {
                                  tempSelected.remove(originalIndex);
                                } else {
                                  _showMinLimitSnack();
                                }
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),
                  // 3. Apply Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        setState(() => _selectedServiceIds = List.from(tempSelected));
                        Navigator.pop(context);
                      },
                      child: const Text("Apply Changes", style: TextStyle(color: Colors.white)),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Place these inside your _ServiceSelectionScreenState class

  void _showLimitReachedSnack() {
    ScaffoldMessenger.of(context).clearSnackBars(); // Clears any existing snackbar first
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Limit reached! Remove a service to add a new one."),
        backgroundColor: Colors.orange[800],
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: "UPGRADE", // Monetization Hook
          textColor: Colors.white,
          onPressed: () {
            // Future: Navigate to a subscription or "Premium" info screen
          },
        ),
      ),
    );
  }

  void _showMinLimitSnack() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Please keep at least $minPinnedServices services for your shortcuts."),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ui = AppUI.factory;
    final promotedPro = allDummyProviders[0];

    return Scaffold(
      appBar: ui.buildAppBar(title: "Order a Service"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("What do you need help with?",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),
            _buildSearchBar(), // <--- NEW SEARCH BAR HERE

            const SizedBox(height: 20),
            const Text("Your Shortcuts",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
            //const SizedBox(height: 15),
            const SizedBox(height: 20),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.85,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _selectedServiceIds.length + 1,
              itemBuilder: (context, index) {
                if (index == _selectedServiceIds.length) {
                  return WigglingCustomizeButton(onTap: _showServicePicker);
                }
                final serviceIndex = _selectedServiceIds[index];
                return _buildCategoryCard(rwandaServices[serviceIndex], context);
              },
            ),

            const SizedBox(height: 32),
            const Text("Featured Professionals",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            _buildMonetizedWrapper(
              label: "SPONSORED",
              color: Colors.orange,
              child: ProviderTile(
                pro: promotedPro,
                onTap: () => _navigateToProfile(context, promotedPro),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(RwandaService service, BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ServiceProvidersListScreen(service: service)),
      ),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: service.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: service.color.withOpacity(0.2), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(service.icon, size: 32, color: service.color),
            const SizedBox(height: 8),
            Text(service.name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildMonetizedWrapper({required String label, required Color color, required Widget child}) {
    return Stack(
      children: [
        child,
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToProfile(BuildContext context, dynamic pro) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ProviderProfileScreen(provider: pro)));
  }
}

// --- SUPPORTING UI COMPONENTS ---

class WigglingCustomizeButton extends StatefulWidget {
  final VoidCallback onTap;
  const WigglingCustomizeButton({super.key, required this.onTap});

  @override
  State<WigglingCustomizeButton> createState() => _WigglingCustomizeButtonState();
}

class _WigglingCustomizeButtonState extends State<WigglingCustomizeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -0.015, end: 0.015).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _animation,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(15),
        child: CustomPaint(
          painter: PremiumDashPainter(),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_circle_outline, size: 30, color: Colors.grey),
                SizedBox(height: 4),
                Text("Customize",
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PremiumDashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 8, dashSpace = 4;
    final paint = Paint()
      ..color = Colors.grey[400]!
      ..strokeWidth = 2.5 // Thick, professional dashed look
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromLTRBR(0, 0, size.width, size.height, const Radius.circular(15));
    final Path path = Path()..addRRect(rrect);

    for (PathMetric pathMetric in path.computeMetrics()) {
      double distance = 0;
      while (distance < pathMetric.length) {
        canvas.drawPath(pathMetric.extractPath(distance, distance + dashWidth), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class RwandaService {
  final String name;
  final IconData icon;
  final Color color;
  RwandaService({required this.name, required this.icon, required this.color});
}

// Add this to the bottom of your file
Widget _previewWrapper(Widget child) {
  return MaterialApp(
    theme: ThemeData(
      useMaterial3: true,
      primarySwatch: Colors.green, // Match your app brand
    ),
    debugShowCheckedModeBanner: false,
    home: Scaffold(body: child),
  );
}

@Preview(name: 'Full Screen View')
Widget previewScreen() => _previewWrapper(const ServiceSelectionScreen());

@Preview(name: 'Button Only')
Widget previewBtn() => _previewWrapper(
    Center(child: WigglingCustomizeButton(onTap: () {}))
);