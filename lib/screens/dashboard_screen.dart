import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teleonco_capacita/google_sheets_service.dart';
import 'package:teleonco_capacita/models/capacitation_model.dart';
import 'package:teleonco_capacita/widgets/bar_chart_widget.dart';
import 'package:teleonco_capacita/widgets/candlestick_chart_widget.dart';
import 'package:teleonco_capacita/widgets/line_chart_widget.dart';
import 'package:teleonco_capacita/widgets/pie_chart_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Timer? _autoRefreshTimer;
  bool _isLoading = true;
  List<Capacitation> allCapacitations = [];
  List<Capacitation> filteredCapacitations = [];

  String selectedMonth = 'Todos';
  String selectedArea = 'Todas';
  String _lastUpdated = '---';

  final List<String> months = ['Todos', 'Jan', 'Fev', 'Mar', 'Abr', 'Mai'];
  final List<String> areas = [
    'Todas',
    'Enfermagem',
    'Medicina',
    'Fisioterapia'
  ];

  @override
  void initState() {
    super.initState();
    _fetchData();

    // 🔁 Atualização automática a cada 5 minutos
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
    if (!auto) {
      setState(() => _isLoading = true);
    }

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
          const SnackBar(
            content: Text('✅ Dados atualizados com sucesso!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Erro ao atualizar dados: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  void applyFilters() {
    setState(() {
      filteredCapacitations = allCapacitations.where((c) {
        final monthMatch = selectedMonth == 'Todos' || c.mes == selectedMonth;
        final areaMatch = selectedArea == 'Todas' || c.area == selectedArea;
        return monthMatch && areaMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600 && size.width < 1100;
    final isMobile = size.width < 600;

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF4F6F9),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _fetchData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Cabeçalho com título, botão e hora
                  Flex(
                    direction: isMobile ? Axis.vertical : Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '📊 Dashboard - Teleonco Capacita',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey[900],
                                ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.access_time,
                                  size: 16, color: Colors.blueGrey),
                              const SizedBox(width: 6),
                              Text(
                                'Última atualização: $_lastUpdated',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: _fetchData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          label: const Text(
                            "Atualizar agora",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 🔹 Filtros
                  Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    children: [
                      _buildDropdown(
                        label: "Mês",
                        value: selectedMonth,
                        items: months,
                        onChanged: (value) {
                          selectedMonth = value!;
                          applyFilters();
                        },
                      ),
                      _buildDropdown(
                        label: "Área",
                        value: selectedArea,
                        items: areas,
                        onChanged: (value) {
                          selectedArea = value!;
                          applyFilters();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // 🔹 Gráficos responsivos
                  ResponsiveGrid(
                    isMobile: isMobile,
                    isTablet: isTablet,
                    children: [
                      _buildChartCard(
                        title: "Taxas de Conclusão por Área",
                        child: PieChartWidget(
                            capacitations: filteredCapacitations),
                      ),
                      _buildChartCard(
                        title: "Evolução de Engajamento",
                        child: LineChartWidget(
                            capacitations: filteredCapacitations),
                      ),
                      _buildChartCard(
                        title: "Comparativo de Áreas (Taxa de Conclusão)",
                        child: BarChartWidget(
                            capacitations: filteredCapacitations),
                      ),
                      _buildChartCard(
                        title: "Indicadores de Satisfação",
                        child: CandlestickChartWidget(
                            capacitations: filteredCapacitations),
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
    );
  }

  // 🔹 Dropdown personalizado
  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return SizedBox(
      width: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.blueGrey[800])),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blueGrey.shade100),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                items: items
                    .map((item) =>
                        DropdownMenuItem(value: item, child: Text(item)))
                    .toList(),
                onChanged: onChanged,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.blueGrey),
                isExpanded: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Card estilizado de gráfico
  Widget _buildChartCard({
    required String title,
    required Widget child,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blueGrey)),
            const SizedBox(height: 12),
            SizedBox(height: 300, child: child),
          ],
        ),
      ),
    );
  }
}

// 🔹 Layout responsivo para grids
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final bool isMobile;
  final bool isTablet;

  const ResponsiveGrid({
    super.key,
    required this.children,
    required this.isMobile,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 2);
    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      childAspectRatio: isMobile ? 1 : 1.6,
      physics: const NeverScrollableScrollPhysics(),
      children: children,
    );
  }
}
