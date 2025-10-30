import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BarChartWidget extends StatelessWidget {
  const BarChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Capacitações por Setor',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          const labels = ['Onco', 'Pedi', 'Geri', 'Outros'];
                          return Text(labels[value.toInt() % labels.length]);
                        },
                      ),
                    ),
                  ),
                  barGroups: [
                    BarChartGroupData(
                        x: 0,
                        barRods: [BarChartRodData(toY: 8, color: Colors.blue)]),
                    BarChartGroupData(x: 1, barRods: [
                      BarChartRodData(toY: 6, color: Colors.orange)
                    ]),
                    BarChartGroupData(x: 2, barRods: [
                      BarChartRodData(toY: 5, color: Colors.green)
                    ]),
                    BarChartGroupData(x: 3, barRods: [
                      BarChartRodData(toY: 3, color: Colors.redAccent)
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
