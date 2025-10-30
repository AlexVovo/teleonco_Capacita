import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:teleonco_capacita/models/capacitation_model.dart';

class LineChartWidget extends StatelessWidget {
  final List<Capacitation> capacitations;

  const LineChartWidget({super.key, required this.capacitations});

  @override
  Widget build(BuildContext context) {
    if (capacitations.isEmpty) {
      return const Center(child: Text('Sem dados para exibir'));
    }

    // Dados por mês
    final Map<String, double> dataMap = {};
    for (var c in capacitations) {
      dataMap[c.mes] = (dataMap[c.mes] ?? 0) + c.taxaConclusao;
    }

    final months = dataMap.keys.toList();
    final spots = List.generate(
        months.length, (i) => FlSpot(i.toDouble(), dataMap[months[i]]!));

    return LineChart(LineChartData(
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          barWidth: 3,
          dotData: FlDotData(show: true),
          color: Colors.blue, // <--- aqui
        ),
      ],
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
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true),
        ),
      ),
      gridData: FlGridData(show: true),
      borderData: FlBorderData(show: false),
    ));
  }
}
