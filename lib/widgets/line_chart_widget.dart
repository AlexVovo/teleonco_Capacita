import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:teleonco_capacita/models/capacitation_model.dart';

class LineChartWidget extends StatelessWidget {
  final List<Capacitation> capacitations;

  const LineChartWidget({super.key, required this.capacitations});

  @override
  Widget build(BuildContext context) {
    if (capacitations.isEmpty) {
      return const Center(
        child: Text(
          'Sem dados para exibir',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    // AGRUPAR TAXA DE ENGAJAMENTO REAL POR MÊS
    final Map<String, List<double>> engajamentoPorMes = {};

    for (var c in capacitations) {
      double taxaReal = 0;

      if (c.inscritos > 0) {
        taxaReal = (c.alunosAtivos / c.inscritos) * 100;
        if (taxaReal > 100) taxaReal = 100;
      }

      engajamentoPorMes.putIfAbsent(c.mes, () => []);
      engajamentoPorMes[c.mes]!.add(taxaReal);
    }

    // ORDENAR MESES
    final months = engajamentoPorMes.keys.toList();
    months.sort((a, b) => _order(a).compareTo(_order(b)));

    // SPOTS
    final spots = List.generate(months.length, (i) {
      final valores = engajamentoPorMes[months[i]]!;
      final media = valores.reduce((a, b) => a + b) / valores.length;
      return FlSpot(i.toDouble(), media);
    });

    return SingleChildScrollView(
      child: Column(
        children: [
          /// 📈 GRÁFICO
          SizedBox(
            height: 300,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: 100,
                backgroundColor: Colors.white,

                // TOOLTIP
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => Colors.blueAccent,
                    tooltipPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    getTooltipItems: (touched) => touched.map((spot) {
                      final m = months[spot.x.toInt()];
                      return LineTooltipItem(
                        "$m\n${spot.y.toStringAsFixed(1)}%",
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // GRID
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  horizontalInterval: 10,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: Colors.grey.withOpacity(0.2),
                  ),
                ),

                borderData: FlBorderData(show: false),

                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            idx >= 0 && idx < months.length ? months[idx] : "",
                            style: TextStyle(
                              fontSize: isMobile ? 10 : 12,
                              color: Colors.black87,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 10,
                      reservedSize: 38,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: TextStyle(
                          fontSize: isMobile ? 10 : 12,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ),

                // LINHAS
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: Colors.blueAccent,
                    barWidth: 4,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Colors.blueAccent.withOpacity(0.25),
                          Colors.blueAccent.withOpacity(0.05),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// 🟦 LEGENDA
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            children: [
              _legendItem(
                Colors.blueAccent,
                "Taxa de Engajamento (0–100%)",
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// caixa de legenda
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
        Text(text, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  int _order(String mes) {
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
