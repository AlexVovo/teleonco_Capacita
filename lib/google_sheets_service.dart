import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'package:teleonco_capacita/models/capacitation_model.dart';

class GoogleSheetsService {
  static const String sheetUrl =
      "https://docs.google.com/spreadsheets/d/e/2PACX-1vQWsJpGVyZ4knBFU7zgYKpkb80DLK64dKcq8MZliQibaIgLvY7d_feOU4pbSDYIbzWYLXu5rJBz3fdd/pub?output=csv";

  static Future<List<Capacitation>> fetchData() async {
    final response = await http.get(Uri.parse(sheetUrl));

    if (response.statusCode == 200) {
      // Faz parse REAL de CSV (tratando vírgulas e aspas corretamente)
      final rows = const CsvToListConverter(
        fieldDelimiter: ',',
        textDelimiter: '"',
        eol: '\n',
      ).convert(response.body);

      final List<Capacitation> data = [];

      // Pula cabeçalho
      for (int i = 1; i < rows.length; i++) {
        final row = rows[i];

        try {
          data.add(Capacitation.fromCsv(
            row.map((e) => e.toString()).toList(),
          ));
        } catch (e) {
          print("⚠️ Erro ao converter linha $i → $e");
        }
      }

      print("✅ Dados carregados: ${data.length}");
      return data;
    } else {
      throw Exception(
        'Falha ao carregar dados: ${response.statusCode} — ${response.reasonPhrase}',
      );
    }
  }
}
