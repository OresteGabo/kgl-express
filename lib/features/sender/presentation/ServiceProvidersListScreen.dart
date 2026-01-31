import 'package:flutter/material.dart';
import 'package:kgl_express/core/constants/mock_data.dart';
import 'package:kgl_express/features/sender/presentation/ProviderProfileScreen.dart';
import 'package:kgl_express/features/sender/presentation/ServiceSelectionScreen.dart';
import 'package:kgl_express/features/sender/presentation/widgets/provider_tile.dart..dart'; // Fixed the double ..dart in your import

class ServiceProvidersListScreen extends StatefulWidget {
  final RwandaService service;

  const ServiceProvidersListScreen({super.key, required this.service});

  @override
  State<ServiceProvidersListScreen> createState() => _ServiceProvidersListScreenState();
}

class _ServiceProvidersListScreenState extends State<ServiceProvidersListScreen> {

  // 1. Logic to filter providers based on the service passed to the widget
  List<ServiceProvider> get _filteredProviders {
    return allDummyProviders
        .where((pro) => pro.specialty.contains(widget.service.name))
        .toList();
  }

  // 2. Logic to simulate fetching data from a server in Kigali
  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      // In a real app, you would re-fetch data from your API here
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the list from our helper getter
    final providers = _filteredProviders;

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.service.name}s in Kigali"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: Colors.teal[700],
        child: providers.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: providers.length,
          itemBuilder: (context, index) {
            final pro = providers[index];
            return ProviderTile(
              pro: pro,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProviderProfileScreen(provider: pro),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Another helper function to keep the build method clean
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            "No ${widget.service.name}s available right now.",
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}