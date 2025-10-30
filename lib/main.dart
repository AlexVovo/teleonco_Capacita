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
        title: 'teleoncoCapacita',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const DashboardScreen(),
      ),
    );
  }
}
