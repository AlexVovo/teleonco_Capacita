/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_map/flutter_map.dart';
//import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:teleonco_capacita/models/capacitation_model.dart';

class MunicipioChoroplethWidget extends StatefulWidget {
  final List<Capacitation> capacitations;
  final String geoAssetPath;

  const MunicipioChoroplethWidget({
    super.key,
    required this.capacitations,
    this.geoAssetPath = 'assets/geo/rs_municipios.geojson',
  });

  @override
  State<MunicipioChoroplethWidget> createState() =>
      _MunicipioChoroplethWidgetState();
}

class _MunicipioChoroplethWidgetState
    extends State<MunicipioChoroplethWidget> {

  Map<String, int> _valuesByMunicipio = {};
  List<_PolygonFeature> _features = [];
  bool _loading = true;

  String? _selectedMunicipio;
  int? _selectedValue;

  @override
  void initState() {
    super.initState();
    _prepareData();
  }

  Future<void> _prepareData() async {
    final map = <String, int>{};

    // soma profissionais por município
    for (var c in widget.capacitations) {
      final name = c.municipio.trim().toUpperCase();
      if (name.isEmpty) continue;
      map[name] = (map[name] ?? 0) + c.profissionaisCapacitados;
    }

    final raw = await rootBundle.loadString(widget.geoAssetPath);
    final jsonData = json.decode(raw);

    final features = <_PolygonFeature>[];

    for (var f in jsonData["features"]) {
      final props = f["properties"] ?? {};
      final geo = f["geometry"];

      if (geo == null) continue;

      final candidates = [
        props["NM_MUNICIP"],
        props["name"],
        props["nome"],
        props["municipio"],
      ];

      final name = (candidates.firstWhere(
        (e) => e != null && e.toString().trim().isNotEmpty,
        orElse: () => "",
      )).toString().toUpperCase();

      final type = geo["type"];
      final coords = geo["coordinates"];

      final polys = <List<LatLng>>[];

      if (type == "Polygon") {
        for (var ring in coords) {
          polys.add([
            for (var pt in ring)
              LatLng((pt[1] as num).toDouble(), (pt[0] as num).toDouble())
          ]);
        }
      } else if (type == "MultiPolygon") {
        for (var poly in coords) {
          for (var ring in poly) {
            polys.add([
              for (var pt in ring)
                LatLng((pt[1] as num).toDouble(), (pt[0] as num).toDouble())
            ]);
          }
        }
      }

      if (polys.isNotEmpty) {
        features.add(_PolygonFeature(name, polys));
      }
    }

    setState(() {
      _valuesByMunicipio = map;
      _features = features;
      _loading = false;
    });
  }

  Color _colorFor(int value, int max) {
    final t = max == 0 ? 0.0 : (value / max).clamp(0.0, 1.0);

    if (t < 0.5) {
      return Color.lerp(Colors.green.shade300, Colors.yellow.shade600, t / 0.5)!;
    } else {
      return Color.lerp(Colors.yellow.shade600, Colors.red.shade700, (t - 0.5) / 0.5)!;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    final maxVal = _valuesByMunicipio.values.isEmpty
        ? 1
        : _valuesByMunicipio.values.reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Mapa Choropleth — RS (Profissionais Capacitados)",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        const SizedBox(height: 10),

        SizedBox(
          height: 420,
          child: FlutterMap(
            mapController: MapController(),
            options: MapOptions(
              initialCenter: LatLng(-29.9, -53.0),
              initialZoom: 6.5,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),

              onTap: (_, __) => setState(() {
                _selectedMunicipio = null;
                _selectedValue = null;
              })
            ),

            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              ),

              // ---- LAYER CORRETO PARA FLUTTER_MAP 8.2.2 ----
              PolygonLayer(
                polygons: _features.map((f) {
                  final value = _valuesByMunicipio[f.name] ?? 0;
                  final color = _colorFor(value, maxVal).withOpacity(0.85);

                  return Polygon(
                    points: f.polygons.expand((p) => p).toList(),
                    color: color,
                    borderColor: Colors.black.withOpacity(0.25),
                    borderStrokeWidth: 0.5,
                    isFilled: true,
                    hitValue: f.name,   // usado para identificar clique
                  );
                }).toList(),

                polygonHitDetection: PolygonHitDetectionOptions(
                  onTap: (tapPosition, hitValue) {
                    final muni = hitValue.toString().toUpperCase();
                    final val = _valuesByMunicipio[muni] ?? 0;

                    setState(() {
                      _selectedMunicipio = muni;
                      _selectedValue = val;
                    });
                  },
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        _legend(maxVal),

        if (_selectedMunicipio != null)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "$_selectedMunicipio — $_selectedValue profissionais",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }

  Widget _legend(int maxVal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        final from = ((i / 5) * maxVal).round();
        final to = (((i + 1) / 5) * maxVal).round();
        final color = _colorFor(from, maxVal);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Column(
            children: [
              Container(width: 28, height: 12, color: color),
              Text("$from – $to"),
            ],
          ),
        );
      }),
    );
  }
}

class _PolygonFeature {
  final String name;
  final List<List<LatLng>> polygons;
  _PolygonFeature(this.name, this.polygons);
}*/
