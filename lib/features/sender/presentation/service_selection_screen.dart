import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kgl_express/core/constants/mock_data.dart';
import 'package:kgl_express/core/presentation/ui_factory/platform_ui.dart';
import 'package:kgl_express/features/sender/presentation/provider_profile_screen.dart';
import 'package:kgl_express/features/sender/presentation/service_providers_list_screen.dart';
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
  final int maxPinnedServices = 18;
  final int minPinnedServices = 2;

  // Inside _ServiceSelectionScreenState, add a controller
  final TextEditingController _searchController = TextEditingController();

// Add this helper method to build the Search Bar
  Widget _buildSearchBar() {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _searchController,
        style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface),
        decoration: InputDecoration(
          hintText: "Search for services...",
          hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: Icon(Icons.clear, color: theme.colorScheme.onSurfaceVariant),
            onPressed: () => setState(() => _searchController.clear()),
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
    String searchQuery = "";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Let Container handle color
      builder: (context) {
        final theme = Theme.of(context);
        final ui = AppUI.factory;

        return StatefulBuilder(
          builder: (context, setModalState) {
            final filteredServices = rwandaServices.where((s) {
              return s.name.toLowerCase().contains(searchQuery.toLowerCase());
            }).toList();

            return Container(
              padding: const EdgeInsets.all(24),
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface, // Adaptive background
                borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Customize your Grid",
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),

                  // THEMED MODAL SEARCH BAR
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      style: TextStyle(color: theme.colorScheme.onSurface),
                      decoration: InputDecoration(
                        hintText: "Search services...",
                        hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                        prefixIcon: Icon(Icons.search, size: 20, color: theme.colorScheme.onSurfaceVariant),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onChanged: (value) => setModalState(() => searchQuery = value),
                    ),
                  ),
                  const SizedBox(height: 15),

                  Expanded(
                    child: filteredServices.isEmpty
                        ? Center(
                      child: Text(
                        "No services found.",
                        style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                      ),
                    )
                        : ListView.builder(
                      itemCount: filteredServices.length,
                      itemBuilder: (context, index) {
                        final service = filteredServices[index];

                        // Important: Get the consistent index from the master list
                        final originalIndex = rwandaServices.indexOf(service);
                        final isSelected = tempSelected.contains(originalIndex);

                        // Get the same color used in the grid
                        final dynamicColor = _getServiceColor(context, originalIndex);

                        return ui.buildSelectionTile(
                          title: service.name,
                          icon: service.icon,
                          iconColor: dynamicColor, // <--- Dynamic Theme Color applied
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

                  // THEMED APPLY BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary, // Brand Primary
                        foregroundColor: theme.colorScheme.onPrimary, // Contrast Text
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        setState(() => _selectedServiceIds = List.from(tempSelected));
                        Navigator.pop(context);
                      },
                      child: const Text("Apply Changes", style: TextStyle(fontWeight: FontWeight.bold)),
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
  void _showLimitReachedSnack() {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Limit reached! Remove a service to add a new one."),
        backgroundColor: theme.colorScheme.errorContainer, // Standard M3 error role
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: "UPGRADE",
          textColor: theme.colorScheme.onErrorContainer,
          onPressed: () {},
        ),
      ),
    );
  }

  // Place these inside your _ServiceSelectionScreenState class



  void _showMinLimitSnack() {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Please keep at least $minPinnedServices services."),
        backgroundColor: theme.colorScheme.inverseSurface,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ui = AppUI.factory;
    final promotedPro = allDummyProviders[0];
    final theme = Theme.of(context);

    return Scaffold(
      appBar: ui.buildAppBar(title: "Order a Service"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("What do you need help with?",
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),

            const SizedBox(height: 10),
            _buildSearchBar(),

            const SizedBox(height: 20),
            Text("Your Shortcuts",
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.secondary)),
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

                // 1. Get the ID from your selected list
                final serviceIndex = _selectedServiceIds[index];

                // 2. Map that ID to the specific service and a theme color
                // We use serviceIndex so the color stays consistent for that specific service
                final service = rwandaServices[serviceIndex];
                final dynamicColor = _getServiceColor(context, serviceIndex);

                return _buildCategoryCard(service, context, dynamicColor);
              },
            ),

            const SizedBox(height: 32),
            Text("Featured Professionals",
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
            const SizedBox(height: 15),

            _buildMonetizedWrapper(
              label: "SPONSORED",
              child: ProviderTile(pro: promotedPro, onTap: () {_navigateToProfile(context, promotedPro);}),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildCategoryCard(RwandaService service, BuildContext context, Color brandColor) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ServiceProvidersListScreen(service: service)),
      ),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          // We use a very light version of the brand color for the background
          color: brandColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: brandColor.withValues(alpha: 0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(service.icon, size: 32, color: brandColor), // Icon uses the brand color
            const SizedBox(height: 8),
            Text(
              service.name,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface, // Text stays standard for readability
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildMonetizedWrapper({required String label, required Widget child}) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        child,
        Positioned(
          top: 10, right: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              // Tertiary is great for 'Promoted' or 'Secondary' callouts
              color: theme.colorScheme.tertiary,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              label,
              style: TextStyle(
                  color: theme.colorScheme.onTertiary,
                  fontSize: 8,
                  fontWeight: FontWeight.bold
              ),
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
    final theme = Theme.of(context);
    return RotationTransition(
      turns: _animation,
      child: InkWell(
        onTap: widget.onTap,
        child: CustomPaint(
          // Pass the theme color to the painter
          painter: PremiumDashPainter(color: theme.colorScheme.outlineVariant),
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_circle_outline, size: 30, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(height: 4),
                Text(
                  "Customize",
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
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
  final Color color;
  PremiumDashPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 8, dashSpace = 4;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0 // Thick, professional dashed look
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
  RwandaService({required this.name, required this.icon});
}


Color _getServiceColor(BuildContext context, int index) {
  final colorScheme = Theme.of(context).colorScheme;

  // These roles provide much better saturation for icons
  final List<Color> palette = [
    colorScheme.primary,           // Strong Gold
    colorScheme.tertiary,          // Strong Green
    colorScheme.secondary,         // Strong Olive
    colorScheme.primaryFixedDim,   // Medium-Strong Gold (Better than Container)
    colorScheme.tertiaryFixedDim,  // Medium-Strong Green
    colorScheme.secondaryFixedDim, // Medium-Strong Olive
    colorScheme.error,             // Red (Great for contrast)
    colorScheme.inversePrimary,    // A different shade of the brand gold
  ];

  return palette[index % palette.length];
}