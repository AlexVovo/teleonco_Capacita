import 'package:flutter/material.dart';
import 'package:teleonco_capacita/widgets/bar_chart_widget.dart';
import 'package:teleonco_capacita/widgets/candlestick_chart_widget.dart';
import 'package:teleonco_capacita/widgets/line_chart_widget.dart';
import 'package:teleonco_capacita/widgets/pie_chart_widget.dart';
import 'package:teleonco_capacita/models/capacitation_model.dart';

late List<Capacitation> allCapacitations;
late List<Capacitation> filteredCapacitations;

@override
void initState() {
  initState();

  // Dados fictícios usando a classe do modelo
  allCapacitations = [
    Capacitation(
        mes: 'Jan',
        area: 'Enfermagem',
        taxaConclusao: 80,
        taxaEngajamento: 70,
        satisfacao: 4.5,
        municipio: '',
        tipo: '',
        profissionaisCapacitados: 0,
        capacitacoesRealizadas: 0),
    Capacitation(
        mes: 'Jan',
        area: 'Medicina',
        taxaConclusao: 90,
        taxaEngajamento: 85,
        satisfacao: 4.8,
        municipio: '',
        tipo: '',
        profissionaisCapacitados: 0,
        capacitacoesRealizadas: 0),
    Capacitation(
        mes: 'Fev',
        area: 'Fisioterapia',
        taxaConclusao: 75,
        taxaEngajamento: 60,
        satisfacao: 4.2,
        municipio: '',
        tipo: '',
        profissionaisCapacitados: 0,
        capacitacoesRealizadas: 0),
    Capacitation(
        mes: 'Mar',
        area: 'Enfermagem',
        taxaConclusao: 85,
        taxaEngajamento: 78,
        satisfacao: 4.6,
        municipio: '',
        tipo: '',
        profissionaisCapacitados: 0,
        capacitacoesRealizadas: 0),
    Capacitation(
        mes: 'Abr',
        area: 'Medicina',
        taxaConclusao: 92,
        taxaEngajamento: 88,
        satisfacao: 4.9,
        municipio: '',
        tipo: '',
        profissionaisCapacitados: 0,
        capacitacoesRealizadas: 0),
  ];

  filteredCapacitations = List.from(allCapacitations);
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String selectedMonth = 'Todos';
  String selectedArea = 'Todas';

  final List<String> months = ['Todos', 'Jan', 'Fev', 'Mar', 'Abr', 'Mai'];
  final List<String> areas = [
    'Todas',
    'Enfermagem',
    'Medicina',
    'Fisioterapia'
  ];

  late List<Capacitation> allCapacitations;
  late List<Capacitation> filteredCapacitations;

  @override
  void initState() {
    super.initState();

    // Dados fictícios
    allCapacitations = [
      Capacitation(
          mes: 'Jan',
          area: 'Enfermagem',
          taxaConclusao: 80,
          taxaEngajamento: 70,
          satisfacao: 4.5,
          municipio: '',
          tipo: '',
          profissionaisCapacitados: 0,
          capacitacoesRealizadas: 0),
      Capacitation(
          mes: 'Jan',
          area: 'Medicina',
          taxaConclusao: 90,
          taxaEngajamento: 85,
          satisfacao: 4.8,
          municipio: '',
          tipo: '',
          profissionaisCapacitados: 0,
          capacitacoesRealizadas: 0),
      Capacitation(
          mes: 'Fev',
          area: 'Fisioterapia',
          taxaConclusao: 75,
          taxaEngajamento: 60,
          satisfacao: 4.2,
          municipio: '',
          tipo: '',
          profissionaisCapacitados: 0,
          capacitacoesRealizadas: 0),
      Capacitation(
          mes: 'Mar',
          area: 'Enfermagem',
          taxaConclusao: 85,
          taxaEngajamento: 78,
          satisfacao: 4.6,
          municipio: '',
          tipo: '',
          profissionaisCapacitados: 0,
          capacitacoesRealizadas: 0),
      Capacitation(
          mes: 'Abr',
          area: 'Medicina',
          taxaConclusao: 92,
          taxaEngajamento: 88,
          satisfacao: 4.9,
          municipio: '',
          tipo: '',
          profissionaisCapacitados: 0,
          capacitacoesRealizadas: 0),
    ];

    filteredCapacitations = List.from(allCapacitations);
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
    final isMobile = size.width < 800;

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
                    const SizedBox(height: 16),

                    // 🔹 FILTROS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        DropdownButton<String>(
                          value: selectedMonth,
                          items: months
                              .map((m) =>
                                  DropdownMenuItem(value: m, child: Text(m)))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              selectedMonth = value;
                              applyFilters();
                            }
                          },
                        ),
                        const SizedBox(width: 24),
                        DropdownButton<String>(
                          value: selectedArea,
                          items: areas
                              .map((a) =>
                                  DropdownMenuItem(value: a, child: Text(a)))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              selectedArea = value;
                              applyFilters();
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 🔹 Linha 1
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: [
                        SizedBox(
                          width: isMobile ? size.width * 0.9 : size.width * 0.4,
                          height: 300,
                          child: PieChartWidget(
                              capacitations: filteredCapacitations),
                        ),
                        SizedBox(
                          width: isMobile ? size.width * 0.9 : size.width * 0.5,
                          height: 300,
                          child: LineChartWidget(
                              capacitations: filteredCapacitations),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 🔹 Linha 2
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: [
                        SizedBox(
                          width: isMobile ? size.width * 0.9 : size.width * 0.4,
                          height: 300,
                          child: BarChartWidget(
                              capacitations: filteredCapacitations),
                        ),
                        SizedBox(
                          width: isMobile ? size.width * 0.9 : size.width * 0.5,
                          height: 300,
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
      ),
    );
  }
}
