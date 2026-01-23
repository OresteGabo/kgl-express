import 'package:flutter/material.dart';
import 'package:kgl_express/core/enums/user_role.dart';
import 'package:kgl_express/features/auth/presentation/widgets/role_card.dart';
import 'package:kgl_express/features/sender/presentation/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingRoleScreen extends StatelessWidget {
  const OnboardingRoleScreen({super.key});

  Future<void> _finishOnboarding(BuildContext context, UserRole role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('default_role', role.name);

    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) =>  const PlaceholderHomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setup KGL Express')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.settings_suggest, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            const Text(
              'One-time Configuration',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Select your primary role. This helps us customize your experience in Kigali.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Suggestion Alert
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha:0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Not sure what to pick? We recommend starting as an "Individual".',
                      style: TextStyle(color: Colors.blueAccent, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Role Cards
            ...UserRole.values.map((role) => RoleCard(
              role: role,
              isRecommended: role == UserRole.individual,
              onTap: () => _finishOnboarding(context, role),
            )),

            const SizedBox(height: 20),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Note: You can use multiple roles and change your default preference at any time in the Settings menu.',
                style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}