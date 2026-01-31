import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kgl_express/core/constants/mock_data.dart';
import 'package:kgl_express/core/enums/ProviderType.dart';
import 'package:kgl_express/features/sender/presentation/ServiceProvidersListScreen.dart';
import 'package:kgl_express/features/sender/presentation/widgets/provider_tile.dart..dart';
import 'package:marquee/marquee.dart';
import 'ProviderProfileScreen.dart';


class ServiceSelectionScreen extends StatelessWidget {

  const ServiceSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final featuredPro = allDummyProviders[Random().nextInt(allDummyProviders.length)];
    final featureProCompany = allDummyProviders.last;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order a Service", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("What do you need help with?",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            // 1. Categories Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: rwandaServices.length,
              itemBuilder: (context, index) {
                final service = rwandaServices[index];
                return _buildCategoryCard(service,context);
              },
            ),

            const SizedBox(height: 30),
            const Text("Top Rated Professionals",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            ProviderTile( // Use the new shared widget
              pro: featuredPro,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProviderProfileScreen(provider: featuredPro)),
              ),
            ),
            ProviderTile( // Use the new shared widget
              pro: featureProCompany,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProviderProfileScreen(provider: featureProCompany)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(RwandaService service,BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ServiceProvidersListScreen(service: service),
            ),
          );
        },
      child: Container(
        decoration: BoxDecoration(
          color: service.color.withValues(alpha:0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(service.icon, size: 40, color: service.color),
            const SizedBox(height: 10),
            Text(service.name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
          ],
        ),
      ),
    );
  }
/*
  Widget _buildProTile(BuildContext context, ServiceProvider pro, VoidCallback onTap) {
    final bool isCompany = pro.type == ProviderType.company;
    final Color themeColor = isCompany ? Colors.blue[700]! : Colors.teal[700]!;
    final Color bgColor = isCompany ? Colors.blue[50]! : Colors.teal[50]!;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: bgColor,
          child: Icon(pro.type.icon, color: themeColor),
        ),
        title: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 22,
                child: pro.name.length > 20
                    ? Marquee(
                  text: pro.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  scrollAxis: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  blankSpace: 20.0,
                  velocity: 30.0,
                  pauseAfterRound: const Duration(seconds: 2),
                )
                    : Text(
                  pro.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            if (isCompany) ...[
              const SizedBox(width: 8),
              const CompanyBadge(), // Using the extracted widget
            ],
          ],
        ),
        subtitle: Text(
          "${pro.specialty} • ${pro.location}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 18),
            const SizedBox(width: 4),
            Text(pro.rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
*/
}

class RwandaService {
  final String name;
  final IconData icon;
  final Color color;

  RwandaService({required this.name, required this.icon, required this.color});
}


