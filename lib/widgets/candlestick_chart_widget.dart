import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:teleonco_capacita/models/capacitation_model.dart';

class CandlestickChartWidget extends StatelessWidget {
  final List<Capacitation> capacitations;

  const CandlestickChartWidget({super.key, required this.capacitations});

  @override
  Widget build(BuildContext context) {
    if (capacitations.isEmpty) {
      return const Center(child: Text('Sem dados para exibir'));
    }

    final Map<String, List<double>> monthSatisfacao = {};
    for (var c in capacitations) {
      monthSatisfacao[c.mes] = (monthSatisfacao[c.mes] ?? [])
        ..add(c.satisfacao);
    }

    final months = monthSatisfacao.keys.toList();

    final candles = List.generate(months.length, (i) {
      final values = monthSatisfacao[months[i]]!;
      final min = values.reduce((a, b) => a < b ? a : b);
      final max = values.reduce((a, b) => a > b ? a : b);
      final avg = values.reduce((a, b) => a + b) / values.length;
      return BarChartGroupData(x: i, barRods: [
        BarChartRodData(toY: max, fromY: min, color: Colors.purple, width: 12),
      ]);
    });

    return BarChart(
      BarChartData(
        barGroups: candles,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  return Text(
                      index >= 0 && index < months.length ? months[index] : '');
                }),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
        ),
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}
