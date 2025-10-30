class Capacitation {
  final String municipio;
  final int profissionaisCapacitados;
  final int capacitacoesRealizadas;
  final double taxaConclusao; // 0.0 a 1.0
  final double taxaEngajamento; // 0.0 a 1.0
  final double satisfacao; // 0.0 a 5.0

  Capacitation({
    required this.municipio,
    required this.profissionaisCapacitados,
    required this.capacitacoesRealizadas,
    required this.taxaConclusao,
    required this.taxaEngajamento,
    required this.satisfacao,
  });
}
