import 'package:flutter/material.dart';
import '../models/capacitation_model.dart';

class CapacitationProvider extends ChangeNotifier {
  final List<Capacitation> _capacitations = [
    // Exemplo de dados compatíveis com o novo modelo
    Capacitation(
      mes: 'Jan',
      area: 'Enfermagem',
      municipio: 'São Paulo',
      tipo: 'Presencial',
      profissionaisCapacitados: 120,
      capacitacoesRealizadas: 8,
      inscritos: 150,
      certificados: 130,
      alunosAtivos: 140,
      satisfacao: 92,
      divulgacoesMes: 5,
      taxaConclusao: (130 / 150) * 100,
      taxaEngajamento: (140 / 150) * 100,
    ),
    Capacitation(
      mes: 'Jan',
      area: 'Medicina',
      municipio: 'Rio de Janeiro',
      tipo: 'EAD',
      profissionaisCapacitados: 95,
      capacitacoesRealizadas: 6,
      inscritos: 110,
      certificados: 86,
      alunosAtivos: 100,
      satisfacao: 90,
      divulgacoesMes: 4,
      taxaConclusao: (86 / 110) * 100,
      taxaEngajamento: (100 / 110) * 100,
    ),
  ];

  List<Capacitation> get capacitations => _capacitations;
}
