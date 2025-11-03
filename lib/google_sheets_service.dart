import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:teleonco_capacita/models/capacitation_model.dart';

class GoogleSheetsService {
  static const String sheetUrl =
      "https://docs.google.com/spreadsheets/d/e/2PACX-1vS_5xPGs9vnZss7rXgTkApryvvD1uVR5fPKhhMTeSBIy5kSVu-GS4d_bp_2FcIUrdm9mKGA9Pe4DW3i/pub?output=csv";

  static Future<List<Capacitation>> fetchData() async {
    final response = await http.get(Uri.parse(sheetUrl));

    if (response.statusCode == 200) {
      final rows = const LineSplitter().convert(response.body);
      final List<Capacitation> data = [];

      for (int i = 1; i < rows.length; i++) {
        final row = rows[i].split(',');

        if (row.length >= 9) {
          data.add(Capacitation.fromCsv(row));
        }
      }

      print("✅ Dados carregados: ${data.length}");
      return data;
    } else {
      throw Exception(
          'Falha ao carregar dados: ${response.statusCode} — ${response.reasonPhrase}');
    }
  }
}
