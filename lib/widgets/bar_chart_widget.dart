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

    return SingleChildScrollView(
      child: Column(
        children: [
          /// Gráfico com altura fixa (evita overflow)
          SizedBox(
            height: 300,
            child: BarChart(
              BarChartData(
                barGroups: List.generate(months.length, (i) {
                  return BarChartGroupData(
                    x: i,
                    barsSpace: 8,
                    barRods: [
                      BarChartRodData(
                        toY: conclusaoMap[months[i]]! / capacitations.length,
                        color: Colors.green,
                        width: 14,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      BarChartRodData(
                        toY: engajamentoMap[months[i]]! / capacitations.length,
                        color: Colors.orange,
                        width: 14,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            index >= 0 && index < months.length
                                ? months[index]
                                : '',
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                ),
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// LEGENDA (nunca estoura agora)
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            runSpacing: 8,
            children: [
              _legendItem(Colors.green, "Conclusão (%)"),
              _legendItem(Colors.orange, "Engajamento (%)"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
