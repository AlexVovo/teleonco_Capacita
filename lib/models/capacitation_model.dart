class Capacitation {
  final String mes;
  final String area;
  final double taxaConclusao;
  final double taxaEngajamento;
  final double satisfacao;
  final String municipio;
  final String tipo;
  final int profissionaisCapacitados;
  final int capacitacoesRealizadas;

  Capacitation({
    required this.mes,
    required this.area,
    required this.taxaConclusao,
    required this.taxaEngajamento,
    required this.satisfacao,
    required this.municipio,
    required this.tipo,
    required this.profissionaisCapacitados,
    required this.capacitacoesRealizadas,
  });

  factory Capacitation.fromCsv(List<String> row) {
    // 🔹 Garantir que vírgulas decimais sejam tratadas corretamente
    double parseDouble(String s) {
      return double.tryParse(s.replaceAll(',', '.')) ?? 0.0;
    }

    int parseInt(String s) {
      return int.tryParse(s.replaceAll(',', '').trim()) ?? 0;
    }

    // 🔹 Corrigir linhas quebradas por vírgulas dentro de números
    if (row.length > 9) {
      // Junta novamente tudo após o índice 4 em uma string e redivide
      final merged = <String>[
        row[0],
        row[1],
        row[2],
        row[3],
        row.sublist(4).join(','),
      ];
      row = merged;
    }

    return Capacitation(
      mes: row.isNotEmpty ? row[0].trim() : '',
      area: row.length > 1 ? row[1].trim() : '',
      taxaConclusao: row.length > 2 ? parseDouble(row[2].trim()) : 0.0,
      taxaEngajamento: row.length > 3 ? parseDouble(row[3].trim()) : 0.0,
      satisfacao: row.length > 4 ? parseDouble(row[4].trim()) : 0.0,
      municipio: row.length > 5 ? row[5].trim() : '',
      tipo: row.length > 6 ? row[6].trim() : '',
      profissionaisCapacitados: row.length > 7 ? parseInt(row[7]) : 0,
      capacitacoesRealizadas: row.length > 8 ? parseInt(row[8]) : 0,
    );
  }
}
