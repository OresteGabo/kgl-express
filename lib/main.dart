import 'package:flutter/material.dart';
import 'package:kgl_express/features/auth/presentation/onboarding_screen.dart';
import 'package:kgl_express/features/sender/presentation/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kgl_express/core/theme/app_theme.dart';

import 'core/theme/theme.dart';


void main() async {
  // Ensure Flutter is initialized before calling SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final String? savedRole = prefs.getString('default_role');

  runApp(KGLExpressApp(initialRole: savedRole));
}
/*
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
*/


class KGLExpressApp extends StatelessWidget {
  final String? initialRole;
  const KGLExpressApp({super.key, this.initialRole});

  @override
  Widget build(BuildContext context) {
    // Initialize the theme with your app's TextTheme
    final materialTheme = MaterialTheme(Theme.of(context).textTheme);

    return MaterialApp(
      title: 'KGL Express',
      // Using your generated light theme
      theme: materialTheme.light(),
      // Using your generated dark theme
      darkTheme: materialTheme.dark(),
      themeMode: ThemeMode.system,
      home: initialRole == null
          ? const OnboardingRoleScreen()
          : const PlaceholderHomeScreen(),
    );
  }
}




