// provider_tile.dart
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:kgl_express/core/enums/provider_type.dart';
import '../provider_profile_screen.dart';

class ProviderTile extends StatelessWidget {
  final ServiceProvider pro;
  final VoidCallback onTap;

  const ProviderTile({super.key, required this.pro, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isCompany = pro.type == ProviderType.company;
    final Color themeColor = isCompany ? Colors.blue[700]! : Colors.teal[700]!;
    final Color bgColor = isCompany ? Colors.blue[50]! : Colors.teal[50]!;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: _buildLeading(bgColor, themeColor),
        title: _buildTitle(isCompany),
        subtitle: Text("${pro.specialty} • ${pro.location}"),
        trailing: _buildTrailing(),
      ),
    );
  }

  // --- Helper Chunks ---

  Widget _buildLeading(Color bgColor, Color themeColor) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: ClipOval(
        child: (pro.imageUrl != null && pro.imageUrl!.isNotEmpty)
            ? Image.network(
          pro.imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Icon(pro.type.icon, color: themeColor),
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return Center(child: CircularProgressIndicator(strokeWidth: 2, color: themeColor));
          },
        )
            : Icon(pro.type.icon, color: themeColor),
      ),
    );
  }

  Widget _buildTitle(bool isCompany) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 22,
            child: pro.name.length > 20 ? _buildMarqueeName() : _buildStaticName(),
          ),
        ),
        if (isCompany) ...[
          const SizedBox(width: 8),
          const CompanyBadge(),
        ],
      ],
    );
  }

  Widget _buildMarqueeName() {
    return Marquee(
      text: pro.name,
      style: const TextStyle(fontWeight: FontWeight.bold),
      blankSpace: 20.0,
      velocity: 30.0,
      pauseAfterRound: const Duration(seconds: 2),
    );
  }

  Widget _buildStaticName() {
    return Text(
      pro.name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTrailing() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star, color: Colors.amber, size: 18),
        const SizedBox(width: 4),
        Text(pro.rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
        const Icon(Icons.chevron_right, color: Colors.grey),
      ],
    );
  }
}

class CompanyBadge extends StatelessWidget {
  const CompanyBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        "COMPANY",
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.blue[800],
        ),
      ),
    );
  }
}