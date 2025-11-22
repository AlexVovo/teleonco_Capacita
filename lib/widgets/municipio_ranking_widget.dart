import 'package:flutter/material.dart';
import 'package:teleonco_capacita/models/capacitation_model.dart';

class MunicipioRankingWidget extends StatelessWidget {
  final List<Capacitation> capacitations;
  final int topN;

  const MunicipioRankingWidget({
    super.key,
    required this.capacitations,
    this.topN = 10,
  });

  @override
  Widget build(BuildContext context) {
    if (capacitations.isEmpty) {
      return const Center(child: Text('Sem dados para exibir'));
    }

    /// AGRUPAR PROFISSIONAIS POR MUNICÍPIO
    final Map<String, int> map = {};
    for (var c in capacitations) {
      map[c.municipio] = (map[c.municipio] ?? 0) + c.profissionaisCapacitados;
    }

    /// ORDENAR POR MAIOR
    final entries = map.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final display = entries.take(topN).toList();
    final maxValue = display.first.value.toDouble();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TÍTULO
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              "Ranking de Municípios por Profissionais Capacitados",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
          ),

          /// LISTA DE BARRAS
          ListView.builder(
            itemCount: display.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final item = display[index];
              final percent = item.value / maxValue;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    /// MUNICÍPIO À ESQUERDA
                    SizedBox(
                      width: 120,
                      child: Text(
                        item.key,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// BARRA HORIZONTAL
                    Expanded(
                      child: Stack(
                        children: [
                          /// Fundo
                          Container(
                            height: 22,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),

                          /// Barra colorida
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 450),
                            height: 22,
                            width: MediaQuery.of(context).size.width *
                                0.55 *
                                percent,
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              item.value.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 14),

          /// LEGENDA
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            children: [
              _legendItem(
                Colors.blueAccent,
                "Profissionais Capacitados",
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ITEM DE LEGENDA
  Widget _legendItem(Color color, String label) {
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
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
