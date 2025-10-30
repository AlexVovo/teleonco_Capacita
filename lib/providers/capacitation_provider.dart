import 'package:flutter/material.dart';
import '../models/capacitation_model.dart';

class CapacitationProvider extends ChangeNotifier {
  final List<Capacitation> _capacitations = [
    // Exemplo de dados
    Capacitation(
      municipio: 'São Paulo',
      profissionaisCapacitados: 120,
      capacitacoesRealizadas: 8,
      taxaConclusao: 0.85,
      taxaEngajamento: 0.9,
      satisfacao: 4.2,
    ),
    Capacitation(
      municipio: 'Rio de Janeiro',
      profissionaisCapacitados: 95,
      capacitacoesRealizadas: 6,
      taxaConclusao: 0.78,
      taxaEngajamento: 0.88,
      satisfacao: 4.0,
    ),
  ];

  List<Capacitation> get capacitations => _capacitations;
}
