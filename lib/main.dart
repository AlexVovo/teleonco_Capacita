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

        // =========================
        // 🌞 TEMA CLARO (opcional)
        // =========================
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          scaffoldBackgroundColor: const Color(0xFFF4F6F9),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF3B82F6),
            brightness: Brightness.light,
          ),
          cardTheme: CardThemeData(
            elevation: 3,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 1,
            titleTextStyle: TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            iconTheme: IconThemeData(color: Color(0xFF1E293B)),
          ),
        ),

        // =========================
        // 🌙 TEMA ESCURO (FINAL)
        // =========================
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,

          // 🔥 FUNDO REALMENTE ESCURO
          scaffoldBackgroundColor: const Color(0xFF020617),

          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF3B82F6),
            brightness: Brightness.dark,
            background: const Color(0xFF020617),
            surface: const Color(0xFF020617),
            primary: const Color(0xFF60A5FA),
            secondary: const Color(0xFF818CF8),
          ),

          // 🎴 CARDS
          cardTheme: CardThemeData(
            elevation: 2,
            color: const Color(0xFF020617),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),

          // 📝 TEXTOS
          textTheme: const TextTheme(
            headlineSmall: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFFE5E7EB),
            ),
            titleMedium: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFFE5E7EB),
            ),
            bodyMedium: TextStyle(
              color: Color(0xFF94A3B8),
            ),
          ),

          // 🧭 APPBAR
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF020617),
            elevation: 1,
            titleTextStyle: TextStyle(
              color: Color(0xFFE5E7EB),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            iconTheme: IconThemeData(color: Color(0xFFE5E7EB)),
          ),

          dividerColor: const Color(0xFF1E293B),
        ),

        // 🔒 FORÇAR DARK MODE
        themeMode: ThemeMode.dark,
        // 👉 Troque para ThemeMode.system se quiser automático

        home: const DashboardScreen(),
      ),
    );
  }
}
