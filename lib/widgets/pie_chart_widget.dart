import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PieChartWidget extends StatelessWidget {
  const PieChartWidget({super.key});

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
              'Distribuição por Área',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: PieChart(
                PieChartData(
                  sectionsSpace: 4,
                  centerSpaceRadius: 40,
                  sections: [
                    PieChartSectionData(
                      color: Colors.blue,
                      value: 40,
                      title: 'Oncologia\n40%',
                      radius: 70,
                      titleStyle:
                          const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    PieChartSectionData(
                      color: Colors.orange,
                      value: 30,
                      title: 'Pediatria\n30%',
                      radius: 70,
                      titleStyle:
                          const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    PieChartSectionData(
                      color: Colors.green,
                      value: 20,
                      title: 'Geriatria\n20%',
                      radius: 70,
                      titleStyle:
                          const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    PieChartSectionData(
                      color: Colors.redAccent,
                      value: 10,
                      title: 'Outros\n10%',
                      radius: 70,
                      titleStyle:
                          const TextStyle(color: Colors.white, fontSize: 14),
                    ),
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
