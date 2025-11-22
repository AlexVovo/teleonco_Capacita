import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:teleonco_capacita/models/capacitation_model.dart';

class GoogleSheetsService {
  static const String sheetUrl =
      "https://docs.google.com/spreadsheets/d/e/2PACX-1vQWsJpGVyZ4knBFU7zgYKpkb80DLK64dKcq8MZliQibaIgLvY7d_feOU4pbSDYIbzWYLXu5rJBz3fdd/pub?output=csv";

  static Future<List<Capacitation>> fetchData() async {
    final response = await http.get(Uri.parse(sheetUrl));

    if (response.statusCode == 200) {
      final rows = const LineSplitter().convert(response.body);
      final List<Capacitation> data = [];

      // pula cabeçalho
      for (int i = 1; i < rows.length; i++) {
        final row = rows[i].split(',');

        if (row.length >= 11) {
          data.add(Capacitation.fromCsv(row));
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
