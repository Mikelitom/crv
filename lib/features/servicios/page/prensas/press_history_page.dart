import 'package:flutter/material.dart';
import '../../../dashboard/presentation/widgets/header.dart';
import '../../widgets/vehiculos/history_inspections_feed.dart';
import '../../widgets/vehiculos/history_tech_info.dart';
import '../../widgets/vehiculos/history_payment_vault.dart';

class PressHistoryPage extends StatelessWidget {
  final String pressId;
  const PressHistoryPage({super.key, required this.pressId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            CustomHeader(
              title: "Expediente de Maquinaria: $pressId",
              actionIcon: Icons.arrow_back_ios_new,
              onActionTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 32),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(flex: 3, child: HistoryInspectionsFeed()),
                const SizedBox(width: 32),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: const [
                      HistoryTechInfo(),
                      SizedBox(height: 24),
                      HistoryPaymentVault(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}