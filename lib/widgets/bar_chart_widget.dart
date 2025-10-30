import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:teleonco_capacita/models/capacitation_model.dart';

class BarChartWidget extends StatelessWidget {
  final List<Capacitation> capacitations;

  const BarChartWidget({super.key, required this.capacitations});

  @override
  Widget build(BuildContext context) {
    if (capacitations.isEmpty) {
      return const Center(child: Text('Sem dados para exibir'));
    }

    final Map<String, double> conclusaoMap = {};
    final Map<String, double> engajamentoMap = {};

    for (var c in capacitations) {
      conclusaoMap[c.mes] = (conclusaoMap[c.mes] ?? 0) + c.taxaConclusao;
      engajamentoMap[c.mes] = (engajamentoMap[c.mes] ?? 0) + c.taxaEngajamento;
    }

    final months = conclusaoMap.keys.toList();

    return BarChart(
      BarChartData(
        barGroups: List.generate(months.length, (i) {
          return BarChartGroupData(x: i, barRods: [
            BarChartRodData(
                toY: conclusaoMap[months[i]]! / capacitations.length,
                color: Colors.green,
                width: 12),
            BarChartRodData(
                toY: engajamentoMap[months[i]]! / capacitations.length,
                color: Colors.orange,
                width: 12),
          ]);
        }),
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
