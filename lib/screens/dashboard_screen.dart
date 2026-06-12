import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:teleonco_capacita/google_sheets_service.dart';
import 'package:teleonco_capacita/models/capacitation_model.dart';
import 'package:teleonco_capacita/widgets/municipio_ranking_widget.dart';

// Widgets
import 'package:teleonco_capacita/widgets/pie_chart_widget.dart';
import 'package:teleonco_capacita/widgets/bar_chart_widget.dart';
import 'package:teleonco_capacita/widgets/line_chart_widget.dart';
import 'package:teleonco_capacita/widgets/candlestick_chart_widget.dart';
import 'package:teleonco_capacita/screens/divulgacao_chart_widget.dart';
import 'package:teleonco_capacita/screens/funnel_chart_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Timer? _autoRefreshTimer;
  bool _isLoading = true;

  List<Capacitation> all = [];
  List<Capacitation> filtered = [];

  String selectedMonth = 'Todos';
  String selectedArea = 'Todas';
  String selectedMunicipio = 'Todos';
  String selectedTipo = 'Todos';

  String lastUpdated = '---';

  final months = [
    'Todos',
    'Jan',
    'Fev',
    'Mar',
    'Abr',
    'Mai',
    'Jun',
    'Jul',
    'Ago',
    'Set',
    'Out',
    'Nov',
    'Dez'
  ];

  @override
  void initState() {
    super.initState();
    _fetchData();

    _autoRefreshTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      _fetchData(auto: true);
    });
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchData({bool auto = false}) async {
    if (!auto) setState(() => _isLoading = true);

    try {
      final data = await GoogleSheetsService.fetchData();
      final now = DateFormat('HH:mm').format(DateTime.now());

      setState(() {
        all = data;
        filtered = List.from(all);
        lastUpdated = now;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void applyFilters() {
    setState(() {
      filtered = all.where((c) {
        final byMonth = selectedMonth == "Todos" || c.mes == selectedMonth;
        final byArea = selectedArea == "Todas" || c.area == selectedArea;
        final byMun =
            selectedMunicipio == "Todos" || c.municipio == selectedMunicipio;
        final byTipo = selectedTipo == "Todos" || c.tipo == selectedTipo;
        return byMonth && byArea && byMun && byTipo;
      }).toList();
    });
  }

  // ---------- KPI CARD ----------
  Widget kpiCard(String title, String value, IconData icon, Color color) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 160, maxWidth: 220),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Row(
          children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: color.withOpacity(.15),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                Text(value,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20)),
              ],
            ),
          )
        ],
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // ---------- KPIs ----------
    int totalProfissionais =
        filtered.fold(0, (a, b) => a + b.profissionaisCapacitados);
    int totalCapacitacoes =
        filtered.fold(0, (a, b) => a + b.capacitacoesRealizadas);
    double mediaConclusao = filtered.isEmpty
        ? 0
        : filtered.fold(0.0, (a, b) => a + b.taxaConclusao) / filtered.length;
    double mediaEngajamento = filtered.isEmpty
        ? 0
        : filtered.fold(0.0, (a, b) => a + b.taxaEngajamento) / filtered.length;
    double mediaSatisfacao = filtered.isEmpty
        ? 0
        : filtered.fold(0.0, (a, b) => a + b.satisfacao) / filtered.length;
    int totalDivulgacao = filtered.fold(0, (a, b) => a + b.divulgacoesMes);

    final allMunicipios = [
      'Todos',
      ...{...all.map((e) => e.municipio)}
    ];
    final allTipos = [
      'Todos',
      ...{...all.map((e) => e.tipo)}
    ];
    final allAreas = [
      'Todas',
      ...{...all.map((e) => e.area)}
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 720;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _fetchData(),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 12 : 24,
                vertical: isMobile ? 12 : 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------- HEADER ----------
                  isMobile
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("📊 Dashboard Teleonco Capacita",
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text("Atualizado: $lastUpdated"),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("📊 Dashboard Teleonco Capacita",
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold)),
                            Text("Atualizado: $lastUpdated"),
                          ],
                        ),
                  const SizedBox(height: 20),

                  // ---------- KPIs RESPONSIVOS ----------
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      kpiCard("Profissionais Capacitados",
                          "$totalProfissionais", Icons.group, Colors.blue),
                      kpiCard("Capacitações", "$totalCapacitacoes",
                          Icons.school, Colors.green),
                      kpiCard(
                          "Conclusão Média",
                          "${mediaConclusao.toStringAsFixed(1)}%",
                          Icons.check_circle,
                          Colors.orange),
                      kpiCard(
                          "Engajamento Médio",
                          "${mediaEngajamento.toStringAsFixed(1)}%",
                          Icons.trending_up,
                          Colors.purple),
                      kpiCard(
                          "Satisfação Média",
                          mediaSatisfacao.toStringAsFixed(1),
                          Icons.star,
                          Colors.amber),
                      kpiCard("Divulgação / Mês", "$totalDivulgacao",
                          Icons.campaign, Colors.red),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // ---------- FILTROS RESPONSIVOS ----------
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      filtro("Mês", selectedMonth, months, (v) {
                        selectedMonth = v!;
                        applyFilters();
                      }),
                      filtro("Área", selectedArea, allAreas, (v) {
                        selectedArea = v!;
                        applyFilters();
                      }),
                      filtro("Município", selectedMunicipio, allMunicipios,
                          (v) {
                        selectedMunicipio = v!;
                        applyFilters();
                      }),
                      filtro("Tipo", selectedTipo, allTipos, (v) {
                        selectedTipo = v!;
                        applyFilters();
                      }),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ---------- GRÁFICOS ----------
                  chartCard(
                    "Distribuição por Área",
                    PieChartWidget(capacitations: filtered),
                    isMobile: isMobile,
                  ),
                  chartCard(
                    "Conclusão por Área",
                    BarChartWidget(capacitations: filtered),
                    isMobile: isMobile,
                  ),
                  chartCard(
                    "Engajamento por Mês",
                    LineChartWidget(capacitations: filtered),
                    isMobile: isMobile,
                  ),
                  chartCard(
                    "Satisfação",
                    CandlestickChartWidget(capacitations: filtered),
                    isMobile: isMobile,
                  ),
                  chartCard(
                    "Inscritos x Ativos x Certificados",
                    FunnelChartWidget(capacitations: filtered),
                    isMobile: isMobile,
                  ),
                  chartCard(
                    "Alcance da Divulgação",
                    DivulgacaoChartWidget(capacitations: filtered),
                    isMobile: isMobile,
                  ),
                  chartCard(
                    "Ranking de Municípios",
                    MunicipioRankingWidget(capacitations: filtered),
                    isMobile: isMobile,
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ---------- FILTRO ----------
  Widget filtro(String label, String value, List<String> items,
      void Function(String?) onChanged) {
    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                items: items
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ---------- CARD DOS GRÁFICOS ----------
  Widget chartCard(String title, Widget child, {bool isMobile = false}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: const EdgeInsets.symmetric(vertical: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),

            /// Altura agora é **flexível e segura**
            SizedBox(
              height: isMobile ? 300 : 350,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
