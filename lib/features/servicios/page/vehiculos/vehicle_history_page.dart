import 'package:crv_reprosisa/features/servicios/widgets/vehiculos/history_inspections_feed.dart';
import 'package:flutter/material.dart';
import '../../../dashboard/presentation/widgets/header.dart';
import '../../widgets/vehiculos/history_tech_info.dart';
import '../../widgets/vehiculos/history_payment_vault.dart';

class VehicleHistoryPage extends StatelessWidget {
  final String vehicleId;
  const VehicleHistoryPage({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth > 1000;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                CustomHeader(title: "Expediente: $vehicleId", actionIcon: Icons.arrow_back_ios_new),
                const SizedBox(height: 32),
                if (isDesktop) _desktopView() else _mobileView(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _desktopView() {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: HistoryInspectionsFeed()),
        SizedBox(width: 32),
        Expanded(flex: 2, child: Column(children: [HistoryTechInfo(), SizedBox(height: 24), HistoryPaymentVault()])),
      ],
    );
  }

  Widget _mobileView() {
    return const Column(children: [HistoryTechInfo(), SizedBox(height: 24), HistoryPaymentVault(), SizedBox(height: 32), HistoryInspectionsFeed()]);
  }
}