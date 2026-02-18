import 'package:flutter/material.dart';
import '../../../dashboard/presentation/widgets/header.dart';
import '../../widgets/vehiculos/document_vault_panel.dart';
import '../../widgets/vehiculos/history_inspections_feed.dart';
import '../../widgets/vehiculos/history_tech_info.dart';

class VehicleHistoryPage extends StatelessWidget {
  final String vehicleId;
  const VehicleHistoryPage({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth > 1200;
          return SingleChildScrollView(
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
                    if (isDesktop) _desktopView() else _mobileView(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _desktopView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SECCIÓN IZQUIERDA: Tus Reportes de Inspección (Área principal)
        const Expanded(flex: 3, child: HistoryInspectionsFeed()),
        const SizedBox(width: 32),
        // SECCIÓN DERECHA: Info técnica y Carpetas de documentos
        Expanded(
          flex: 2, 
          child: Column(
            children: const [
              HistoryTechInfo(), 
              SizedBox(height: 24), 
              HistoryDocumentsPanel(),
            ]
          )
        ),
      ],
    );
  }

  Widget _mobileView() {
    return Column(children: const [
      HistoryTechInfo(), 
      SizedBox(height: 24), 
      HistoryDocumentsPanel(), 
      SizedBox(height: 32), 
      HistoryInspectionsFeed()
    ]);
  }
}