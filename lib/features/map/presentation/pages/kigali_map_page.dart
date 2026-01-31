import 'package:flutter/material.dart';
import '../../data/map_repository.dart';
import '../../models/osm_models.dart';
import '../widgets/kigali_map_painter.dart';

class KigaliMapPage extends StatefulWidget {
  const KigaliMapPage({super.key});

  @override
  State<KigaliMapPage> createState() => _KigaliMapPageState();
}

class _KigaliMapPageState extends State<KigaliMapPage> {
  final MapRepository _repo = MapRepository();
  List<OSMWay> _ways = [];
  bool _isLoading = true;

  // Map state (start centered on Kigali City Tower area)
  double _zoom = 150000.0;
  Offset _offset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _loadKigali();
  }

  Future<void> _loadKigali() async {
    // These bounds cover central Kigali (-1.94, 30.06)
    final ways = await _repo.getVisibleMapData(-1.97, -1.92, 30.01, 30.10);
    setState(() {
      _ways = ways;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kigali Custom Map")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : InteractiveViewer( // Standard Flutter widget for pan/zoom
        boundaryMargin: const EdgeInsets.all(100),
        minScale: 0.1,
        maxScale: 10,
        child: CustomPaint(
          size: Size.infinite,
          painter: KigaliMapPainter(
            ways: _ways,
            zoom: _zoom,
            offset: _offset,
          ),
        ),
      ),
    );
  }
}