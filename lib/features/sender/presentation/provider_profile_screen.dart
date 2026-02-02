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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          _buildSliverHeader(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMainInfo(context),
                  const SizedBox(height: 24),
                  _buildStatsRow(context),
                  Divider(height: 48, color: theme.colorScheme.outlineVariant),
                  _buildAboutSection(context),
                  Divider(height: 48, color: theme.colorScheme.outlineVariant),
                  _buildPaymentSection(context, provider),
                  const SizedBox(height: 32),
                  _buildPortfolioSection(context),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
      // bottomSheet color handled in its helper
      bottomSheet: _buildBottomButtons(context),
    );
  }

  Widget _buildSliverHeader(BuildContext context) {
    final theme = Theme.of(context);
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: theme.colorScheme.primary, // Brand Primary
      foregroundColor: theme.colorScheme.onPrimary,
      actions: [
        IconButton(
          icon: CircleAvatar(
            backgroundColor: theme.colorScheme.onPrimary.withValues(alpha: 0.2),
            child: Icon(Icons.share, color: theme.colorScheme.onPrimary, size: 20),
          ),
          onPressed: () => ContactUtils.shareProviderProfile(context, provider),
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primaryFixedDim,
              ],
            ),
          ),
          child: Center(
            child: Hero(
              tag: 'profile-${provider.name}',
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.colorScheme.onPrimary, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withValues(alpha: 0.2),
                      blurRadius: 15,
                    )
                  ],
                ),
                child: ClipOval(
                  child: provider.imageUrl != null
                      ? Image.network(
                    provider.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) => Icon(
                        Icons.person,
                        size: 80,
                        color: theme.colorScheme.primaryContainer
                    ),
                  )
                      : Icon(Icons.person, size: 80, color: theme.colorScheme.primary),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainInfo(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(provider.name,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                )),
            const SizedBox(width: 8),
            Icon(Icons.verified, color: theme.colorScheme.primary, size: 24),
            if (provider.type == ProviderType.company) ...[
              const SizedBox(width: 8),
              const CompanyBadge(),
            ]
          ],
        ),
        const SizedBox(height: 4),
        Text("${provider.specialty} • ${provider.location}",
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            )),
      ],
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(context, "Rating", provider.rating.toString(), Icons.star),
        _buildStatItem(context, "Jobs", provider.jobsCompleted.toString(), Icons.check_circle),
        _buildStatItem(context, "Experience", "5+ Yrs", Icons.trending_up),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, IconData icon) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.tertiary),
        const SizedBox(height: 6),
        Text(value, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("About Me", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Text(provider.bio, style: theme.textTheme.bodyMedium?.copyWith(height: 1.6)),
      ],
    );
  }

  Widget _buildPortfolioSection(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Past Work / Portfolio", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context, index) => Container(
              width: 150,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Icon(Icons.image, color: theme.colorScheme.onSurfaceVariant),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant)),
        boxShadow: [
          BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4)
          )
        ],
      ),
      child: SafeArea( // Added for notched phones
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => ContactUtils.makeCall(provider.phoneNumber),
                icon: const Icon(Icons.phone),
                label: const Text("Call Now"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            const SizedBox(width: 16),
            _buildWhatsAppButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWhatsAppButton(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 56, // Match button height
      width: 56,
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer, // Semantic use of Tertiary for secondary action
        borderRadius: BorderRadius.circular(16),
      ),
      child: IconButton(
          icon: Icon(Icons.message, color: theme.colorScheme.onTertiaryContainer),
          onPressed: () => ContactUtils.openWhatsApp(provider.phoneNumber, provider.name)
      ),
    );
  }

  Widget _buildPaymentSection(BuildContext context, ServiceProvider provider) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Accepted Payments", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildSecurityWarning(context),
        const SizedBox(height: 20),
        _buildPaymentMethodsGrid(context, provider),
      ],
    );
  }

  Widget _buildSecurityWarning(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.3), // Safety warning uses errorContainer
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.errorContainer),
      ),
      child: Row(
        children: [
          Icon(Icons.gpp_maybe, color: theme.colorScheme.onErrorContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Paying through the app is more secured. Claiming in case of a problem is much faster.",
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onErrorContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsGrid(BuildContext context, ServiceProvider provider) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: provider.acceptedPayments.map((method) => _buildPaymentChip(context, method)).toList(),
    );
  }

  Widget _buildPaymentChip(BuildContext context, PaymentMethod method) {
    final theme = Theme.of(context);
    final bool isCash = method == PaymentMethod.cash;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isCash ? theme.colorScheme.surfaceContainer : theme.colorScheme.secondaryContainer,
        border: Border.all(
          color: isCash ? theme.colorScheme.outlineVariant : theme.colorScheme.secondary.withValues(alpha: 0.2),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPaymentIcon(context, method),
          const SizedBox(width: 8),
          Text(
            method.label,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: isCash ? FontWeight.normal : FontWeight.bold,
              color: isCash ? theme.colorScheme.onSurfaceVariant : theme.colorScheme.onSecondaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentIcon(BuildContext context, PaymentMethod method) {
    if (method.assetPath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.asset(method.assetPath!, width: 20, height: 20, fit: BoxFit.cover),
      );
    }
    return Icon(method.icon, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant);
  }
}

class ServiceProvider {
  final String name;
  final Speciality specialty;
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