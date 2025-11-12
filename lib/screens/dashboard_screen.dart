// imports adicionais
import 'package:teleonco_capacita/services/google_sheets_service.dart';
import 'package:teleonco_capacita/services/pdf_export_service.dart';
import 'package:printing/printing.dart';
import 'dart:typed_data';

// Dentro de _DashboardScreenState, já existia _fetchData() — substitua pelo que segue:
Future<void> _fetchData({bool auto = false}) async {
  if (!auto) setState(() => _isLoading = true);

  try {
    final data = await GoogleSheetsService.fetchData();
    final now = DateFormat('HH:mm').format(DateTime.now());
    setState(() {
      allCapacitations = data;
      filteredCapacitations = List.from(allCapacitations);
      _isLoading = false;
      _lastUpdated = now;
    });

    if (!auto && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Dados atualizados com sucesso!'), duration: Duration(seconds: 2)),
      );
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Erro ao atualizar dados: $e'), duration: const Duration(seconds: 3)),
      );
    }
    setState(() => _isLoading = false);
  }
}

// Em seu AppBar / cabeçalho, já havia um ElevatedButton de Atualizar.
// Adicione um outro botão ao lado para exportar PDF:
Row(
  children: [
    ElevatedButton.icon(
      onPressed: _fetchData,
      icon: const Icon(Icons.refresh),
      label: const Text('Atualizar agora'),
    ),
    const SizedBox(width: 8),
    ElevatedButton.icon(
      onPressed: () async {
        try {
          final bytes = await PdfExportService.generateInstitutionalPdf(filteredCapacitations);
          // Usar printing para abrir diálogo de salvar/compartilhar/visualizar
          await Printing.sharePdf(bytes: bytes, filename: 'relatorio_conclusoes_teleoncoped.pdf');
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao gerar PDF: $e')));
        }
      },
      icon: const Icon(Icons.picture_as_pdf),
      label: const Text('Exportar PDF'),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
    ),
  ],
),

// Abaixo dos gráficos, adicione a tabela:
const SizedBox(height: 16),
Text("📋 Tabela de Registros", style: Theme.of(context).textTheme.titleMedium),
SizedBox(
  width: double.infinity,
  child: Card(
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Município')),
          DataColumn(label: Text('Profissionais')),
          DataColumn(label: Text('Capacitações')),
          DataColumn(label: Text('Taxa Conclusão')),
          DataColumn(label: Text('Engajamento')),
          DataColumn(label: Text('Satisfação')),
        ],
        rows: filteredCapacitations.map((c) {
          return DataRow(cells: [
            DataCell(Text(c.municipio)),
            DataCell(Text(c.profissionaisCapacitados.toString())),
            DataCell(Text(c.capacitacoesRealizadas.toString())),
            DataCell(Text((c.taxaConclusao * 100).toStringAsFixed(2) + '%')),
            DataCell(Text((c.taxaEngajamento * 100).toStringAsFixed(2) + '%')),
            DataCell(Text(c.satisfacao.toStringAsFixed(2))),
          ]);
        }).toList(),
      ),
    ),
  ),
),
