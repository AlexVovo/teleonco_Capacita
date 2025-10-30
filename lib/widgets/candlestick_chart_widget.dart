import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CandlestickChartWidget extends StatelessWidget {
  const CandlestickChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Dados simulados (open, high, low, close)
    final data = [
      [2.0, 2.8, 1.8, 2.5],
      [2.5, 3.2, 2.3, 3.0],
      [3.0, 3.5, 2.8, 3.3],
      [3.3, 3.8, 3.0, 3.6],
      [3.6, 4.2, 3.4, 4.0],
    ];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tendência de Desempenho',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: true),
                  barGroups: List.generate(data.length, (i) {
                    final open = data[i][0];
                    final high = data[i][1];
                    final low = data[i][2];
                    final close = data[i][3];
                    final isGain = close >= open;
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: high,
                          fromY: low,
                          color: isGain ? Colors.green : Colors.redAccent,
                          width: 8,
                          borderRadius: BorderRadius.zero,
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
