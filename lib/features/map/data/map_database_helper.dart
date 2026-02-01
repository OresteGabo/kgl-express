import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/osm_models.dart';

class MapDatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "kigali_map.db");

    // Check if the database exists in local storage
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      //print("Creating new copy from asset");

      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Load from assets
      ByteData data = await rootBundle.load(join("assets", "kigali_map.db"));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write to local storage
      await File(path).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(path, readOnly: true);
  }

  // Inside lib/features/map/data/map_database_helper.dart

  Future<List<OSMWay>> queryWaysInBounds(double minLat, double maxLat, double minLon, double maxLon) async {
    final db = await database;

    // 1. Get all nodes within the bounding box
    // We use strings for IDs because your MySQL used VARCHAR(255)
    final List<Map<String, dynamic>> nodeMaps = await db.query(
      'nodes',
      where: 'lat BETWEEN ? AND ? AND lon BETWEEN ? AND ?',
      whereArgs: [minLat, maxLat, minLon, maxLon],
    );

    // Convert to a Map for quick lookup: { "node_id": OSMNode }
    Map<String, OSMNode> nodesInView = {
      for (var m in nodeMaps) m['id'].toString(): OSMNode.fromMap(m)
    };

    if (nodesInView.isEmpty) return [];

    // 2. Find all ways (roads) that use these nodes
    // This JOIN ensures we only get roads that actually have points on your screen
    final String nodeIdsPlaceholder = nodesInView.keys.map((_) => '?').join(',');

    final List<Map<String, dynamic>> wayNodesResults = await db.rawQuery('''
    SELECT way_id, node_id, node_order 
    FROM ways_nodes 
    WHERE way_id IN (
      SELECT DISTINCT way_id FROM ways_nodes WHERE node_id IN ($nodeIdsPlaceholder)
    )
    ORDER BY way_id, node_order
  ''', nodesInView.keys.toList());

    // 3. Group the results into OSMWay objects
    Map<String, List<OSMNode>> waysMap = {};
    for (var row in wayNodesResults) {
      String wayId = row['way_id'].toString();
      String nodeId = row['node_id'].toString();

      // We only add nodes we actually have data for
      if (nodesInView.containsKey(nodeId)) {
        waysMap.putIfAbsent(wayId, () => []).add(nodesInView[nodeId]!);
      }
    }

    return waysMap.entries.map((e) => OSMWay(
        id: e.key,
        nodes: e.value,
        tags: {} // You can add a separate query for tags if needed for Niji
    )).toList();
  }
}