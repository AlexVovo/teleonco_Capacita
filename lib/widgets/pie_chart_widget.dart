import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:teleonco_capacita/models/capacitation_model.dart';

class PieChartWidget extends StatefulWidget {
  final List<Capacitation> capacitations;

  const PieChartWidget({super.key, required this.capacitations});

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  int touchedIndex = -1;
  Offset? touchPosition;

  @override
  Widget build(BuildContext context) {
    final capacitations = widget.capacitations;

    if (capacitations.isEmpty) {
      return const Center(child: Text('Sem dados para exibir'));
    }

    // 🔹 Agrupar dados por área
    final Map<String, int> dataMap = {};
    for (var c in capacitations) {
      dataMap[c.area] = (dataMap[c.area] ?? 0) + 1;
    }

    final total = dataMap.values.fold<int>(0, (a, b) => a + b);
    final entries = dataMap.entries.toList();

    final List<Color> colors = [
      const Color(0xFF1E88E5),
      const Color(0xFF43A047),
      const Color(0xFFF4511E),
      const Color(0xFF8E24AA),
      const Color(0xFF00897B),
      const Color(0xFF6D4C41),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 300;

        return Container(
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(minHeight: 500),
          child: isMobile
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 150,
                      child: _buildChartStack(entries, colors, total),
                    ),
                    const SizedBox(height: 16),
                    _buildScrollableLegend(entries, colors, total,
                        maxHeight: 120),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 320,
                        child: _buildChartStack(entries, colors, total),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 1,
                      child: _buildScrollableLegend(entries, colors, total,
                          maxHeight: 280),
                    ),
                  ],
                ),
        );
      },
    );
  }

  // 🔹 Stack que contém gráfico + tooltip (com limitação segura)
  Widget _buildChartStack(
      List<MapEntry<String, int>> entries, List<Color> colors, int total) {
    return LayoutBuilder(builder: (context, constraints) {
      final chartSize = constraints.biggest;
      return MouseRegion(
        onHover: (event) {
          setState(() {
            touchPosition = Offset(
              event.localPosition.dx.clamp(0, chartSize.width - 150),
              event.localPosition.dy.clamp(20, chartSize.height - 60),
            );
          });
        },
        onExit: (_) {
          setState(() {
            touchedIndex = -1;
            touchPosition = null;
          });
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _buildInteractivePieChart(entries, colors, total),
            if (touchedIndex != -1 && touchPosition != null)
              Positioned(
                left: touchPosition!.dx,
                top: touchPosition!.dy,
                child: _buildTooltip(entries, colors, total),
              ),
          ],
        ),
      );
    });
  }

  // 🔹 Gráfico de pizza interativo
  Widget _buildInteractivePieChart(
      List<MapEntry<String, int>> entries, List<Color> colors, int total) {
    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 45,
        borderData: FlBorderData(show: false),
        startDegreeOffset: -90,
        pieTouchData: PieTouchData(
          enabled: true,
          touchCallback: (event, response) {
            if (!event.isInterestedForInteractions ||
                response == null ||
                response.touchedSection == null) {
              setState(() => touchedIndex = -1);
              return;
            }
            setState(() =>
                touchedIndex = response.touchedSection!.touchedSectionIndex);
          },
        ),
        sections: List.generate(entries.length, (i) {
          final e = entries[i];
          final percent = (e.value / total) * 100;
          final isTouched = i == touchedIndex;
          final double radius = isTouched ? 100 : 80;

          return PieChartSectionData(
            color: colors[i % colors.length],
            value: e.value.toDouble(),
            radius: radius,
            title: '${e.key}\n${percent.toStringAsFixed(1)}%',
            titleStyle: TextStyle(
              fontSize: isTouched ? 15 : 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: const [
                Shadow(
                    blurRadius: 2, color: Colors.black26, offset: Offset(1, 1)),
              ],
            ),
            titlePositionPercentageOffset: 0.6,
          );
        }),
      ),
      swapAnimationDuration: const Duration(milliseconds: 600),
      swapAnimationCurve: Curves.easeOutCubic,
    );
  }

  // 🔹 Tooltip flutuante estável e limitado à área do gráfico
  Widget _buildTooltip(
      List<MapEntry<String, int>> entries, List<Color> colors, int total) {
    final e = entries[touchedIndex];
    final percent = (e.value / total) * 100;

    return IgnorePointer(
      child: AnimatedOpacity(
        opacity: 1,
        duration: const Duration(milliseconds: 150),
        child: Material(
          elevation: 8,
          color: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 160),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.75),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: colors[touchedIndex % colors.length],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    '${e.key}: ${percent.toStringAsFixed(1)}%',
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Legenda rolável
  // 🔹 Legenda com rolagem vertical (corrigido)
  Widget _buildScrollableLegend(
      List<MapEntry<String, int>> entries, List<Color> colors, int total,
      {double maxHeight = 200}) {
    final ScrollController controller = ScrollController();

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Scrollbar(
        controller: controller,
        thumbVisibility: true,
        radius: const Radius.circular(8),
        child: SingleChildScrollView(
          controller: controller, // 👈 controlador adicionado aqui
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Legenda',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[800],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              ...List.generate(entries.length, (i) {
                final e = entries[i];
                final percent = (e.value / total) * 100;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: colors[i % colors.length],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          "${e.key} (${percent.toStringAsFixed(1)}%)",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
