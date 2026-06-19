import 'package:flutter/material.dart';
import '../../../dashboard/presentation/widgets/header.dart';
import '../../widgets/vehiculos/document_vault_panel.dart';
import '../../widgets/vehiculos/history_inspections_feed.dart';
import '../../widgets/vehiculos/history_tech_info.dart';
import '../../widgets/vehiculos/history_payment_vault.dart';

import '../../widgets/active_findings_section.dart';
import '../../widgets/component_status_section.dart';
class VehicleHistoryPage extends StatelessWidget {
  final String vehicleId;
  const VehicleHistoryPage({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1600),
            child: Column(
              children: [
                CustomHeader(
                  title: "Expediente Digital: $vehicleId",
                  actionIcon: Icons.arrow_back_ios_new,
                  onActionTap: () => Navigator.pop(context),
                ),
                const SizedBox(height: 32),
                
                Wrap(
                  spacing: 24,
                  runSpacing: 24,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: [
                    // COLUMNA PRINCIPAL: Operativa y Técnica
                    SizedBox(
                      width: 900, 
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          HistoryTechInfo(),
                          SizedBox(height: 24),
                          
                          // SECCIÓN DE SALUD OPERATIVA (NUEVA)
                          HealthSummarySection(),
                          SizedBox(height: 24),
                          
                          ComponentStatusSection(),
                          SizedBox(height: 24),
                          
                          ActiveFindingsSection(),
                          SizedBox(height: 24),
                          
                          HistoryInspectionsFeed(),
                        ],
                      ),
                    ),
                    
                    // COLUMNA DERECHA: Documental
                    SizedBox(
                      width: 400,
                      child: Column(children: const [
                        HistoryDocumentsPanel(),
                        SizedBox(height: 24),
                        HistoryPaymentVault(),
                      ]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget auxiliar para el resumen de salud (punto 2)
class HealthSummarySection extends StatelessWidget {
  const HealthSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _stat("Alertas Activas", "3", Colors.red),
          _stat("Obs. Componentes", "5", Colors.orange),
          _stat("Servicios Pend.", "1", Colors.blue),
          _stat("Órdenes Abiertas", "1", Colors.purple),
        ],
      ),
    );
  }

  Widget _stat(String label, String value, Color color) => Column(
    children: [
      Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
      Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
    ],
  );
}