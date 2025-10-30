import 'package:flutter/material.dart';
import 'package:teleonco_capacita/widgets/bar_chart_widget.dart';
import 'package:teleonco_capacita/widgets/candlestick_chart_widget.dart';
import 'package:teleonco_capacita/widgets/line_chart_widget.dart';
import 'package:teleonco_capacita/widgets/pie_chart_widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
              constraints: const BoxConstraints(
                maxWidth: 1400, // largura máxima (para monitores grandes)
              ),
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

                    // 🔹 Linha 1: PieChart + LineChart
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: [
                        SizedBox(
                          width: isMobile ? size.width * 0.9 : size.width * 0.4,
                          height: 300,
                          child: const PieChartWidget(),
                        ),
                        SizedBox(
                          width: isMobile ? size.width * 0.9 : size.width * 0.5,
                          height: 300,
                          child: const LineChartWidget(),
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
                          child: const BarChartWidget(),
                        ),
                        SizedBox(
                          width: isMobile ? size.width * 0.9 : size.width * 0.5,
                          height: 300,
                          child: const CandlestickChartWidget(),
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
