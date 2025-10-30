import 'package:flutter/material.dart';
import 'package:teleonco_capacita/widgets/bar_chart_widget.dart';
import 'package:teleonco_capacita/widgets/candlestick_chart_widget.dart';
import 'package:teleonco_capacita/widgets/line_chart_widget.dart';
import 'package:teleonco_capacita/widgets/pie_chart_widget.dart';

// Modelo fictício de capacitação
class Capacitation {
  final String municipio;
  final String area;
  final String tipo;
  final String mes;
  final double taxaConclusao;
  final double taxaEngajamento;
  final double satisfacao;

  Capacitation({
    required this.municipio,
    required this.area,
    required this.tipo,
    required this.mes,
    required this.taxaConclusao,
    required this.taxaEngajamento,
    required this.satisfacao,
    required int profissionaisCapacitados,
    required int capacitacoesRealizadas,
  });
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Dados fictícios
  final List<Capacitation> allData = [
    Capacitation(
        municipio: 'São Paulo',
        area: 'Oncologia',
        tipo: 'Presencial',
        mes: 'Jan',
        taxaConclusao: 90,
        taxaEngajamento: 80,
        satisfacao: 4.5,
        profissionaisCapacitados: 0,
        capacitacoesRealizadas: 0),
    Capacitation(
        municipio: 'São Paulo',
        area: 'Pediatria',
        tipo: 'EAD',
        mes: 'Fev',
        taxaConclusao: 85,
        taxaEngajamento: 70,
        satisfacao: 4.0,
        profissionaisCapacitados: 0,
        capacitacoesRealizadas: 0),
    Capacitation(
        municipio: 'Rio de Janeiro',
        area: 'Oncologia',
        tipo: 'Presencial',
        mes: 'Mar',
        taxaConclusao: 95,
        taxaEngajamento: 90,
        satisfacao: 4.8,
        profissionaisCapacitados: 0,
        capacitacoesRealizadas: 0),
    Capacitation(
        municipio: 'Belo Horizonte',
        area: 'Geriatria',
        tipo: 'EAD',
        mes: 'Abr',
        taxaConclusao: 80,
        taxaEngajamento: 60,
        satisfacao: 3.8,
        profissionaisCapacitados: 0,
        capacitacoesRealizadas: 0),
    // Adicione mais dados fictícios conforme precisar
  ];

  // Valores selecionados nos filtros
  String? selectedMunicipio;
  String? selectedArea;
  String? selectedTipo;
  String? selectedMes;

  List<Capacitation> get filteredData {
    return allData.where((c) {
      final matchMunicipio =
          selectedMunicipio == null || c.municipio == selectedMunicipio;
      final matchArea = selectedArea == null || c.area == selectedArea;
      final matchTipo = selectedTipo == null || c.tipo == selectedTipo;
      final matchMes = selectedMes == null || c.mes == selectedMes;
      return matchMunicipio && matchArea && matchTipo && matchMes;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 800;

    // Opções únicas para cada filtro
    final municipios = allData.map((e) => e.municipio).toSet().toList();
    final areas = allData.map((e) => e.area).toSet().toList();
    final tipos = allData.map((e) => e.tipo).toSet().toList();
    final meses = allData.map((e) => e.mes).toSet().toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Dashboard - Teleonco Capacita',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey[900],
                              ),
                    ),
                    const SizedBox(height: 24),

                    // 🔹 Filtros dinâmicos
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        DropdownButton<String>(
                          value: selectedMunicipio,
                          hint: const Text('Município'),
                          items: municipios
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (val) =>
                              setState(() => selectedMunicipio = val),
                        ),
                        DropdownButton<String>(
                          value: selectedArea,
                          hint: const Text('Área de Atuação'),
                          items: areas
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (val) =>
                              setState(() => selectedArea = val),
                        ),
                        DropdownButton<String>(
                          value: selectedTipo,
                          hint: const Text('Tipo de Capacitação'),
                          items: tipos
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (val) =>
                              setState(() => selectedTipo = val),
                        ),
                        DropdownButton<String>(
                          value: selectedMes,
                          hint: const Text('Mês'),
                          items: meses
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (val) => setState(() => selectedMes = val),
                        ),
                        // Botão para limpar filtros
                        TextButton(
                          onPressed: () => setState(() {
                            selectedMunicipio = null;
                            selectedArea = null;
                            selectedTipo = null;
                            selectedMes = null;
                          }),
                          child: const Text('Limpar filtros'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // 🔹 Linha 1: PieChart + LineChart
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: [
                        SizedBox(
                          width: isMobile ? size.width * 0.9 : size.width * 0.4,
                          height: 300,
                          child: PieChartWidget(
                            capacitations: filteredData,
                          ),
                        ),
                        SizedBox(
                          width: isMobile ? size.width * 0.9 : size.width * 0.5,
                          height: 300,
                          child: LineChartWidget(
                            capacitations: filteredData,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // 🔹 Linha 2: BarChart + CandlestickChart
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: [
                        SizedBox(
                          width: isMobile ? size.width * 0.9 : size.width * 0.4,
                          height: 300,
                          child: BarChartWidget(
                            capacitations: filteredData,
                          ),
                        ),
                        SizedBox(
                          width: isMobile ? size.width * 0.9 : size.width * 0.5,
                          height: 300,
                          child: CandlestickChartWidget(
                            capacitations: filteredData,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
