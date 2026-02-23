import 'package:flutter/material.dart';
import '../model/banda_inspection_model.dart';
import '../widgets/banda_section_table.dart';
import '../../dashboard/presentation/widgets/header.dart';
import '../widgets/customer_section.dart';
import '../../prensas_industriales/widgets/capture_method_selector.dart';
import '../widgets/general_banda.dart';
import '../widgets/rodilleria_section.dart';

class BandaInspectionPage extends StatefulWidget {
  const BandaInspectionPage({super.key});

  @override
  State<BandaInspectionPage> createState() => _BandaInspectionPageState();
}

class _BandaInspectionPageState extends State<BandaInspectionPage> {
  final PageController _pageController = PageController();
  int _currentSectionIndex = 0;
  bool _mostrarRodilleria = false;

  // Secciones obligatorias iniciales
  final List<String> _nombresBase = ["Cola", "Carga", "Peso", "Retorno", "Contrapeso"];

  // Nombres dinámicos para el Stepper de flechas
  List<String> get _nombresPasos {
    List<String> nombres = List.from(_nombresBase);
    if (_mostrarRodilleria) nombres.add("Rodillería");
    return nombres;
  }

  void _activarRodilleria() {
    setState(() => _mostrarRodilleria = true);
    Future.delayed(const Duration(milliseconds: 100), () {
      _pageController.animateToPage(5, 
        duration: const Duration(milliseconds: 500), 
        curve: Curves.easeInOut
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // HEADER INSTITUCIONAL CON BOTÓN DE REGRESO
            CustomHeader(
              title: "Inspección de Bandas", 
              actionIcon: Icons.build, // El icono de la llave inglesa
              onActionTap: () => Navigator.of(context).pop(), // Acción de regresar
            ),
            const SizedBox(height: 24),

            // SECCIÓN CLIENTE
            const CustomerSection(),
            const SizedBox(height: 24),

            // MÉTODO DE CAPTURA
            CaptureMethodSelector(
              onManualFill: () => debugPrint("Llenado manual activado"),
              onScan: () => debugPrint("Escaneo de código activado"),
            ),
            const SizedBox(height: 24),

            // INFORMACIÓN GENERAL DEL REPORTE
            const GeneralBandaInfo(),
            const SizedBox(height: 32),

            // STEPPER DE FLECHAS CONECTADAS
            _buildArrowStepper(_nombresPasos),
            const SizedBox(height: 24),

            // CONTENEDOR DINÁMICO DE SECCIONES (PAGEVIEW)
            SizedBox(
              height: 950, 
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) => setState(() => _currentSectionIndex = index),
                itemCount: _nombresPasos.length,
                itemBuilder: (context, index) {
                  String nombreSeccion = _nombresPasos[index];
                  
                  if (nombreSeccion == "Rodillería") {
                    return const RodilleriaSection(); 
                  }
                  
                  return BandaSectionTable(
                    sectionNumber: index + 1,
                    sectionTitle: nombreSeccion,
                    items: _obtenerDataSeccion(nombreSeccion),
                  );
                },
              ),
            ),

            const SizedBox(height: 32),

            // NAVEGACIÓN Y BOTÓN PARA AGREGAR RODILLERÍA
            _buildFooterNavegacion(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS DE APOYO ---

  Widget _buildArrowStepper(List<String> pasos) {
    return Row(
      children: List.generate(pasos.length, (index) {
        bool isActive = index == _currentSectionIndex;
        bool isCompleted = index < _currentSectionIndex;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: ClipPath(
              clipper: ArrowClipper(),
              child: Container(
                height: 40,
                color: isActive ? const Color(0xFFC62828) : (isCompleted ? Colors.green : Colors.grey.shade300),
                child: Center(
                  child: Text(pasos[index], 
                    style: TextStyle(
                      color: (isActive || isCompleted) ? Colors.white : Colors.black54, 
                      fontWeight: FontWeight.bold, fontSize: 10
                    )),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildFooterNavegacion() {
    bool esUltimaObligatoria = _currentSectionIndex == 4 && !_mostrarRodilleria;
    bool esPasoFinal = _currentSectionIndex == _nombresPasos.length - 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (_currentSectionIndex > 0)
          OutlinedButton(
            onPressed: () => _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease),
            child: const Text("Anterior"),
          ),
        const Spacer(),
        if (esUltimaObligatoria)
          TextButton.icon(
            onPressed: _activarRodilleria,
            icon: const Icon(Icons.add_circle, color: Colors.orange),
            label: const Text("AGREGAR RODILLERÍA", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
          ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () {
            if (!esPasoFinal) {
              _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
            } else {
              // Lógica para finalizar
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFC62828),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(esPasoFinal ? "FINALIZAR" : "SIGUIENTE"),
        ),
      ],
    );
  }

  List<BandaComponentItem> _obtenerDataSeccion(String seccion) {
    if (seccion == "Cola") {
      return [
        BandaComponentItem(accessory: "Banda en la Polea", observationOptions: ["a) Alineada", "b) Desalineada"]),
        BandaComponentItem(accessory: "Raspador de Retorno", observationOptions: ["a) Hay", "b) No hay"]),
        BandaComponentItem(accessory: "Hule Raspador", observationOptions: ["a) Bueno", "b) Cambiar"]),
      ];
    }
    return [];
  }
}

class ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width - 15, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width - 15, size.height);
    path.lineTo(0, size.height);
    path.lineTo(15, size.height / 2);
    path.lineTo(0, 0);
    return path;
  }
  @override bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}