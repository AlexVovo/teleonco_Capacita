import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:teleonco_capacita/models/capacitation_model.dart';

class SatisfactionChartWidget extends StatelessWidget {
  final List<Capacitation> capacitations;

  const SatisfactionChartWidget({super.key, required this.capacitations});

  @override
  Widget build(BuildContext context) {
    if (capacitations.isEmpty) {
      return const Center(child: Text('Sem dados de satisfação para exibir'));
    }

    final isMobile = MediaQuery.of(context).size.width < 600;

    // 🔹 Agrupa notas de satisfação (0–5)
    final ratings = {
      'Excelente':
          capacitations.where((c) => c.satisfacao >= 4.5).length.toDouble(),
      'Bom': capacitations
          .where((c) => c.satisfacao >= 4 && c.satisfacao < 4.5)
          .length
          .toDouble(),
      'Regular': capacitations
          .where((c) => c.satisfacao >= 3 && c.satisfacao < 4)
          .length
          .toDouble(),
      'Ruim': capacitations
          .where((c) => c.satisfacao >= 2 && c.satisfacao < 3)
          .length
          .toDouble(),
      'Não se Aplica':
          capacitations.where((c) => c.satisfacao < 2).length.toDouble(),
    };

    final total = ratings.values.fold(0.0, (a, b) => a + b);
    if (total == 0) {
      return const Center(child: Text('Sem respostas suficientes.'));
    }

    final colors = [
      Colors.green.shade600,
      Colors.lightGreen,
      Colors.orangeAccent,
      Colors.redAccent,
      Colors.grey.shade400,
    ];

    final sections = ratings.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final label = entry.value.key;
      final value = entry.value.value;
      final percent = (value / total) * 100;

      return PieChartSectionData(
        color: colors[index],
        value: value,
        radius: isMobile ? 55 : 70,
        title: '${percent.toStringAsFixed(1)}%',
        titleStyle: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      );
    }).toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 45,
              sectionsSpace: 2,
              borderData: FlBorderData(show: false),
              pieTouchData: PieTouchData(
                enabled: true,
                touchCallback: (event, response) {},
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // 🔹 Legenda visual
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 8,
          children: ratings.keys.toList().asMap().entries.map((entry) {
            final index = entry.key;
            final label = entry.value;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: colors[index],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isMobile ? 11 : 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey[800],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
