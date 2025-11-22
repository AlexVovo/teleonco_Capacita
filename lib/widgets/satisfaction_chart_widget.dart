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

    /// Agrupamento das notas de satisfação
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
      Colors.lightGreen.shade700,
      Colors.orangeAccent,
      Colors.redAccent,
      Colors.grey.shade500,
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final chart = Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                "Nível de Satisfação dos Participantes",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),

            /// GRÁFICO
            SizedBox(
              height: isMobile ? 260 : 340,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// LEGENDA
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 14,
              runSpacing: 10,
              children: ratings.keys.toList().asMap().entries.map((entry) {
                final index = entry.key;
                final label = entry.value;

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 14,
                      height: 14,
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
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey[800],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        );

        /// Evitar overflow em telas pequenas
        return constraints.maxHeight < 400
            ? SingleChildScrollView(child: chart)
            : chart;
      },
    );
  }
}
