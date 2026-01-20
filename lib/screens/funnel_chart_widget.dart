import 'package:flutter/material.dart';
import 'package:teleonco_capacita/models/capacitation_model.dart';

class FunnelChartWidget extends StatelessWidget {
  final List<Capacitation> capacitations;

  const FunnelChartWidget({super.key, required this.capacitations});

  @override
  Widget build(BuildContext context) {
    if (capacitations.isEmpty) {
      return const Center(child: Text("Sem dados para exibir"));
    }

    // Soma geral
    final totalInscritos = capacitations.fold(0, (a, b) => a + b.inscritos);
    final totalAtivos = capacitations.fold(0, (a, b) => a + b.alunosAtivos);
    final totalCertificados =
        capacitations.fold(0, (a, b) => a + b.certificados);

    // Evita divisão por zero
    final maxValue = [totalInscritos, totalAtivos, totalCertificados]
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    final data = [
      _FunnelItem(
          "Inscritos", totalInscritos, Colors.blueAccent.withOpacity(0.7)),
      _FunnelItem("Ativos", totalAtivos, Colors.green.withOpacity(0.7)),
      _FunnelItem(
          "Certificados", totalCertificados, Colors.orange.withOpacity(0.7)),
    ];

    return LayoutBuilder(
      builder: (_, constraints) {
        final barHeight = constraints.maxHeight / 5;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var item in data)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Text(
                      "${item.label}: ${item.value}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Stack(
                      children: [
                        Container(
                          height: barHeight,
                          width: constraints.maxWidth,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        Container(
                          height: barHeight,
                          width: (item.value / maxValue) * constraints.maxWidth,
                          decoration: BoxDecoration(
                            color: item.color,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
          ],
        );
      },
    );
  }
}

class _FunnelItem {
  final String label;
  final int value;
  final Color color;

  _FunnelItem(this.label, this.value, this.color);
}
