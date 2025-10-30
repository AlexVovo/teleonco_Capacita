import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:teleonco_capacita/models/capacitation_model.dart';

class PieChartWidget extends StatelessWidget {
  final List<Capacitation> capacitations;

  const PieChartWidget({super.key, required this.capacitations});

  @override
  Widget build(BuildContext context) {
    if (capacitations.isEmpty) {
      return const Center(child: Text('Sem dados para exibir'));
    }

    // Agrupa por área ou outro critério
    final Map<String, int> dataMap = {};
    for (var c in capacitations) {
      dataMap[c.area] = (dataMap[c.area] ?? 0) + 1;
    }

    final List<PieChartSectionData> sections = dataMap.entries
        .map((e) => PieChartSectionData(
              value: e.value.toDouble(),
              title: '${e.key} (${e.value})',
              color: Colors.primaries[dataMap.keys.toList().indexOf(e.key) %
                  Colors.primaries.length],
              radius: 50,
              titleStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ))
        .toList();

    return PieChart(PieChartData(
      sections: sections,
      sectionsSpace: 2,
      centerSpaceRadius: 20,
      borderData: FlBorderData(show: false),
    ));
  }
}
