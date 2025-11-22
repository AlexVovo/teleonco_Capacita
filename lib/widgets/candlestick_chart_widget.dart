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

      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: max,
            fromY: min,
            width: 16,
            color: Colors.purple,
            borderRadius: const BorderRadius.all(Radius.circular(4)),
          ),
        ],
      );
    });

    return SingleChildScrollView(
      child: Column(
        children: [
          /// 📊 Gráfico — ALTURA RESPONSIVA
          SizedBox(
            height: 300,
            child: BarChart(
              BarChartData(
                barGroups: candles,
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: false),
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
                                : "",
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: true)),
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          /// 🟣 LEGENDA
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 18,
            runSpacing: 10,
            children: [
              _legendItem(
                Colors.purple,
                "Variação de Satisfação (mín–máx)",
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 🔘 Caixa de legenda
  Widget _legendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
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
