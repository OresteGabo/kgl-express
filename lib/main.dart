import 'package:flutter/material.dart';
import 'package:kgl_express/features/auth/presentation/onboarding_screen.dart';
import 'package:kgl_express/features/map/data/map_database_helper.dart';
import 'package:kgl_express/features/sender/presentation/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kgl_express/core/theme/app_theme.dart';
import 'package:sqflite/sqflite.dart';

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
  final dbHelper = MapDatabaseHelper();
  final db = await dbHelper.database;

  // Test 1: Count Nodes
  var nodeCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM nodes'));
  print('Nodes in DB: $nodeCount');

  // Test 2: Get a full path of a Way (Road)
  // This JOIN is exactly what you'll need for drawing the map
  final List<Map<String, dynamic>> roadPoints = await db.rawQuery('''
    SELECT n.lat, n.lon 
    FROM ways_nodes wn
    JOIN nodes n ON wn.node_id = n.id
    WHERE wn.way_id = 'SOME_WAY_ID_FROM_YOUR_MYSQL'
    ORDER BY wn.node_order ASC
  ''');

  for (var point in roadPoints) {
    print('Point: ${point['lat']}, ${point['lon']}');
  }
}





