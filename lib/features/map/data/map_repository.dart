import '../models/osm_models.dart';
import 'map_database_helper.dart'; // Your SQLite helper

class MapRepository {
  final MapDatabaseHelper _dbHelper = MapDatabaseHelper();

  Future<List<OSMWay>> getVisibleMapData(double minLat, double maxLat, double minLon, double maxLon) async {
    try {
      // Now this method exists and handles the SQLite logic!
      return await _dbHelper.queryWaysInBounds(minLat, maxLat, minLon, maxLon);
    } catch (e) {
      print("Error fetching map data: $e");
      return [];
    }
  }
}