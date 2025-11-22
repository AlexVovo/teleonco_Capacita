class Capacitation {
  final String mes;
  final String area;
  final String municipio;
  final String tipo;

  final int profissionaisCapacitados;
  final int capacitacoesRealizadas;

  final int inscritos;
  final int certificados;
  final int alunosAtivos;

  final double satisfacao;
  final int divulgacoesMes;

  final double taxaConclusao; // calculada
  final double taxaEngajamento; // calculada

  Capacitation({
    required this.mes,
    required this.area,
    required this.municipio,
    required this.tipo,
    required this.profissionaisCapacitados,
    required this.capacitacoesRealizadas,
    required this.inscritos,
    required this.certificados,
    required this.alunosAtivos,
    required this.satisfacao,
    required this.divulgacoesMes,
    required this.taxaConclusao,
    required this.taxaEngajamento,
  });

  factory Capacitation.fromCsv(List<String> row) {
    // Helpers
    int toInt(String s) => int.tryParse(s.trim()) ?? 0;
    double toDouble(String s) =>
        double.tryParse(s.replaceAll(',', '.').trim()) ?? 0.0;

    if (row.length < 11) {
      print("⚠️ Linha inválida: $row");
      return Capacitation(
        mes: '',
        area: '',
        municipio: '',
        tipo: '',
        profissionaisCapacitados: 0,
        capacitacoesRealizadas: 0,
        inscritos: 0,
        certificados: 0,
        alunosAtivos: 0,
        satisfacao: 0,
        divulgacoesMes: 0,
        taxaConclusao: 0,
        taxaEngajamento: 0,
      );
    }
    final int inscritos = toInt(row[6]);
    final int certificados = toInt(row[7]);
    final int ativos = toInt(row[8]);

    final double taxaConclusao =
        inscritos > 0 ? (certificados / inscritos * 100).toDouble() : 0.0;

    final double taxaEngajamento =
        inscritos > 0 ? (ativos / inscritos * 100).toDouble() : 0.0;

    return Capacitation(
      mes: row[0].trim(),
      area: row[1].trim(),
      municipio: row[2].trim(),
      tipo: row[3].trim(),
      profissionaisCapacitados: toInt(row[4]),
      capacitacoesRealizadas: toInt(row[5]),
      inscritos: inscritos,
      certificados: certificados,
      alunosAtivos: ativos,
      satisfacao: toDouble(row[9]),
      divulgacoesMes: toInt(row[10]),
      taxaConclusao: taxaConclusao,
      taxaEngajamento: taxaEngajamento,
    );
  }
}
