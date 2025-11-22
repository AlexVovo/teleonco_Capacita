import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:teleonco_capacita/models/capacitation_model.dart';

class DivulgacaoChartWidget extends StatelessWidget {
  final List<Capacitation> capacitations;

  const DivulgacaoChartWidget({super.key, required this.capacitations});

  @override
  Widget build(BuildContext context) {
    if (capacitations.isEmpty) {
      return const Center(child: Text("Sem dados para exibir"));
    }

    final isMobile = MediaQuery.of(context).size.width < 600;

    /// Agrupar divulgação por mês
    final Map<String, int> divulgPorMes = {};
    for (var c in capacitations) {
      divulgPorMes[c.mes] = (divulgPorMes[c.mes] ?? 0) + c.divulgacoesMes;
    }

    /// Ordenar meses
    final meses = divulgPorMes.keys.toList()
      ..sort((a, b) => _orderMes(a).compareTo(_orderMes(b)));

    final double maxValue =
        divulgPorMes.values.fold(0, (a, b) => a > b ? a : b).toDouble();

    return LayoutBuilder(
      builder: (context, constraints) {
        final chart = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TÍTULO
            const Text(
              "Alcance da Divulgação (Ações / Mês)",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),

            const SizedBox(height: 16),

            /// GRÁFICO
            SizedBox(
              height: isMobile ? 260 : 340,
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(show: false),

                  /// GRID
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: 2,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    ),
                  ),

                  maxY: maxValue * 1.3,

                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 2,
                        reservedSize: 32,
                        getTitlesWidget: (value, meta) => Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            fontSize: isMobile ? 9 : 11,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= meses.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              meses[index],
                              style: TextStyle(
                                fontSize: isMobile ? 10 : 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),

                  barGroups: List.generate(meses.length, (i) {
                    final value = divulgPorMes[meses[i]]!.toDouble();

                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: value,
                          width: isMobile ? 18 : 22,
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.blueAccent,
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// LEGENDA
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _legendItem(Colors.blueAccent, "Ações de Divulgação"),
              ],
            ),
          ],
        );

        /// Se o container for muito pequeno, habilita scroll
        return constraints.maxHeight < 450
            ? SingleChildScrollView(child: chart)
            : chart;
      },
    );
  }

  /// Item da legenda
  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  /// Ordem cronológica
  int _orderMes(String mes) {
    const ordem = {
      'Jan': 1,
      'Fev': 2,
      'Mar': 3,
      'Abr': 4,
      'Mai': 5,
      'Jun': 6,
      'Jul': 7,
      'Ago': 8,
      'Set': 9,
      'Out': 10,
      'Nov': 11,
      'Dez': 12,
    };
    return ordem[mes] ?? 999;
  }
}
