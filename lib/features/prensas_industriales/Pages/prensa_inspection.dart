import 'package:flutter/material.dart';
import '../Models/prensa_inspection_model.dart';
import '../widgets/information_general_equipo.dart';
import '../widgets/prestamo_devolucion.dart';
import '../widgets/table_componentes_press.dart';
import '../../dashboard/presentation/widgets/header.dart';
import '../widgets/capture_method_selector.dart';

class PrensaInspectionPage extends StatefulWidget {
  const PrensaInspectionPage({super.key});

  @override
  State<PrensaInspectionPage> createState() => _PrensaInspectionPageState();
}

class _PrensaInspectionPageState extends State<PrensaInspectionPage> {
  bool isScanning = false;

  @override
  Widget build(BuildContext context) {
    // DATOS ESTÁTICOS PARA LA TABLA DE COMPONENTES
    final List<PrensaComponentItem> dataFromDB = [
      PrensaComponentItem(
        unidad: "ML",
        descripcion: "NIVELES DE ACEITE",
        estado: 0,
      ),
      PrensaComponentItem(
        unidad: "PZA",
        descripcion: "MANOMETRO EN CERO",
        estado: 1,
      ),
      PrensaComponentItem(
        unidad: "PZA",
        descripcion: "CONEXIONES ELÉCTRICAS",
        estado: 0,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1600),
            child: Column(
              children: [
                // HEADER CON FUNCIÓN DE REGRESO EN EL ICONO
                CustomHeader(
                  title: "Inspección de Prensas",
                  actionIcon: Icons.build_rounded, // Icono de llave inglesa
                  onActionTap: () => Navigator.of(context).pop(), // Regresa al Dashboard
                ),
                const SizedBox(height: 32),

                // SELECTOR DE MÉTODO DE CAPTURA
                CaptureMethodSelector(
                  onManualFill: () => setState(() => isScanning = false),
                  onScan: () => setState(() => isScanning = true),
                ),

                const SizedBox(height: 32),

                // CAMBIO DINÁMICO ENTRE ESCÁNER Y FORMULARIO
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: isScanning
                      ? _buildScannerView()
                      : _buildFormView(dataFromDB),
                ),
                
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // VISTA DE ESCÁNER QR
  Widget _buildScannerView() {
    return Container(
      key: const ValueKey(1),
      width: double.infinity,
      height: 500,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(
            Icons.videocam_off_rounded,
            color: Colors.white24,
            size: 80,
          ),
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          const Positioned(
            bottom: 40,
            child: Text(
              "POSICIONE EL CÓDIGO QR DENTRO DEL RECUADRO",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // VISTA DEL FORMULARIO TÉCNICO
  Widget _buildFormView(List<PrensaComponentItem> data) {
    return Column(
      key: const ValueKey(2),
      children: [
        // Información general del equipo (Prensa)
        const GeneralEquipmentInfo(equipmentData: {}),
        const SizedBox(height: 24),
        
        // Tabla de componentes técnicos
        PrensaInspectionTable(items: data),
        const SizedBox(height: 24),
        
        // Sección de préstamo e inspector
        const LoanAndInspectorSection(),
      ],
    );
  }
}