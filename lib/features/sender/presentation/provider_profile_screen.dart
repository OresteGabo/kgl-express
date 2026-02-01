import 'package:flutter/material.dart';
import 'package:kgl_express/core/enums/provider_type.dart';
import 'package:kgl_express/core/enums/payment_method.dart';
import 'package:kgl_express/core/utils/contact_utils.dart';
import 'package:kgl_express/features/sender/presentation/widgets/provider_tile.dart..dart';

class ProviderProfileScreen extends StatelessWidget {
  final ServiceProvider provider;

  const ProviderProfileScreen({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverHeader(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMainInfo(),
                  const SizedBox(height: 20),
                  _buildStatsRow(),
                  const Divider(height: 40),
                  _buildAboutSection(),
                  const Divider(height: 40),
                  _buildPaymentSection(provider), // Passing provider to the existing helper
                  const SizedBox(height: 30),
                  _buildPortfolioSection(),
                  const SizedBox(height: 100), // Bottom padding for buttons
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomButtons(),
    );
  }

  // --- Header with Profile Image ---
  Widget _buildSliverHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: Colors.teal[700],
      actions: [
        IconButton(
          icon: const CircleAvatar(
            backgroundColor: Colors.white24,
            child: Icon(Icons.share, color: Colors.white, size: 20),
          ),
          onPressed: () => ContactUtils.shareProviderProfile(context, provider),
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Optional: Add a subtle background pattern or gradient here
            Center(
              child: Hero(
                tag: 'profile-${provider.name}',
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                  ),
                  child: ClipOval(
                    child: provider.imageUrl != null
                        ? Image.network(
                      provider.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => Icon(Icons.person, size: 80, color: Colors.teal[700]),
                    )
                        : Icon(Icons.person, size: 80, color: Colors.teal[700]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Name, Specialty, and Location ---
  Widget _buildMainInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(provider.name,
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)
            ),
            const SizedBox(width: 8),
            const Icon(Icons.verified, color: Colors.blue, size: 24),
            if (provider.type == ProviderType.company) ...[
              const SizedBox(width: 8),
              const CompanyBadge(),
            ]
          ],
        ),
        Text("${provider.specialty} • ${provider.location}",
            style: TextStyle(fontSize: 16, color: Colors.grey[600])),
      ],
    );
  }

  // --- Quick Stats Row ---
  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem("Rating", provider.rating.toString(), Icons.star),
        _buildStatItem("Jobs", provider.jobsCompleted.toString(), Icons.check_circle),
        _buildStatItem("Experience", "5+ Yrs", Icons.trending_up),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.teal[700]),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  // --- Bio Section ---
  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("About Me", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text(provider.bio, style: const TextStyle(fontSize: 15, height: 1.5)),
      ],
    );
  }

  // --- Portfolio Gallery ---
  Widget _buildPortfolioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Past Work / Portfolio",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context, index) => Container(
              width: 150,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.image, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  // --- Persistent Bottom Buttons ---
  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => ContactUtils.makeCall(provider.phoneNumber),
              icon: const Icon(Icons.phone),
              label: const Text("Call Now"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(width: 15),
          _buildWhatsAppButton(),
        ],
      ),
    );
  }

  Widget _buildWhatsAppButton() {
    return Container(
      decoration: BoxDecoration(color: Colors.green[100], borderRadius: BorderRadius.circular(12)),
      child: IconButton(
        icon: const Icon(Icons.message, color: Colors.green),
        onPressed: () => ContactUtils.openWhatsApp(provider.phoneNumber, provider.name)
      ),
    );
  }

  Widget _buildPaymentSection(ServiceProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Accepted Payments",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),

        _buildSecurityWarning(), // Extracted warning card

        const SizedBox(height: 16),

        _buildPaymentMethodsGrid(provider), // Extracted methods list
      ],
    );
  }

// 1. The Safety Warning Card
  Widget _buildSecurityWarning() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.gpp_maybe, color: Colors.amber[900]),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "Paying through the app is more secured. Claiming in case of a problem is much faster.",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

// 2. The Chips/Badges for each Payment Method
  Widget _buildPaymentMethodsGrid(ServiceProvider provider) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: provider.acceptedPayments.map((method) {
        final bool isCash = method == PaymentMethod.cash;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isCash ? Colors.grey[50] : Colors.white,
            border: Border.all(
              color: isCash ? Colors.grey[300]! : Colors.teal.withValues(alpha:0.5),
              width: isCash ? 1 : 1.5,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPaymentIcon(method),
              const SizedBox(width: 8),
              Text(
                method.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isCash ? FontWeight.normal : FontWeight.bold,
                ),
              ),
              if (!isCash) ...[
                const SizedBox(width: 6),
                const Icon(Icons.verified, size: 14, color: Colors.teal),
              ]
            ],
          ),
        );
      }).toList(),
    );
  }

// 3. Icon Logic for Payments
  Widget _buildPaymentIcon(PaymentMethod method) {
    if (method.assetPath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.asset(method.assetPath!, width: 24, height: 24, fit: BoxFit.cover),
      );
    }
    return Icon(method.icon, size: 20, color: Colors.grey[600]);
  }
}

class ServiceProvider {
  final String name;
  final String specialty;
  final String location;
  final double rating;
  final int jobsCompleted;
  final String bio;
  final String phoneNumber;
  final ProviderType type;
  final String? imageUrl;
  final List<String> portfolioImages;
  final List<PaymentMethod> acceptedPayments;



  ServiceProvider({
    required this.name,
    required this.specialty,
    required this.location,
    required this.rating,
    required this.jobsCompleted,
    required this.bio,
    required this.phoneNumber,
    this.imageUrl,
    this.type = ProviderType.individual,
    this.portfolioImages = const [],
    this.acceptedPayments = const [],
  });
}