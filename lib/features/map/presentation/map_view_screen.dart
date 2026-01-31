import 'package:flutter/material.dart';
import '../models/osm_models.dart';
import '../data/map_repository.dart';
import 'widgets/kigali_map_painter.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key});

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  final MapRepository _repository = MapRepository();
  List<OSMWay> _visibleWays = [];
  double _zoom = 1000.0; // Initial zoom for Kigali scale
  Offset _offset = const Offset(0, 0);

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    // Coordinates for Kigali center
    final data = await _repository.getVisibleMapData(-1.97, -1.93, 30.04, 30.10);
    setState(() => _visibleWays = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _offset += details.delta; // Drag the map
          });
        },
        onScaleUpdate: (details) {
          setState(() {
            _zoom *= details.scale; // Zoom in/out
          });
        },
        child: CustomPaint(
          painter: KigaliMapPainter(
            ways: _visibleWays,
            zoom: _zoom,
            offset: _offset,
          ),
          size: Size.infinite,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _zoom += 200),
        child: const Icon(Icons.add),
      ),
    );
  }
}