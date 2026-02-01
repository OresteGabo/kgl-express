import 'package:flutter/material.dart';
import 'package:kgl_express/features/auth/presentation/onboarding_screen.dart';
import 'package:kgl_express/features/sender/presentation/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kgl_express/core/theme/app_theme.dart';


void main() async {
  // Ensure Flutter is initialized before calling SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final String? savedRole = prefs.getString('default_role');
  testDatabase();

  runApp(KGLExpressApp(initialRole: savedRole));
}

class KGLExpressApp extends StatelessWidget {
  final String? initialRole;
  const KGLExpressApp({super.key, this.initialRole});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KGL Express',
      theme: KGLTheme.lightTheme,
      // If a role is saved, skip onboarding and go to "Home"
      home: initialRole == null
          ? const OnboardingRoleScreen()
          : const PlaceholderHomeScreen(),
    );
  }
}

Future<void> testDatabase() async {





}





