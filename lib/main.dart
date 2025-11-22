import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/capacitation_provider.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const TeleoncoCapacitaApp());
}

class TeleoncoCapacitaApp extends StatelessWidget {
  const TeleoncoCapacitaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CapacitationProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TeleOnco Capacita',

        // 🌈 NOVO TEMA VISUAL PROFISSIONAL
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFF4F6F9),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF3B82F6), // azul moderno
            primary: const Color(0xFF3B82F6),
            secondary: const Color(0xFF6366F1),
          ),
          primaryColor: const Color(0xFF3B82F6),
          cardTheme: CardThemeData(
            elevation: 4,
            shadowColor: Colors.black12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Colors.white,
          ),
          textTheme: const TextTheme(
            headlineSmall: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
            bodyMedium: TextStyle(
              color: Color(0xFF475569),
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 1,
            shadowColor: Colors.black12,
            titleTextStyle: TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            iconTheme: IconThemeData(color: Color(0xFF1E293B)),
          ),
        ),

        home: const DashboardScreen(),
      ),
    );
  }
}
