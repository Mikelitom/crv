import 'package:flutter/material.dart';
import '../../widgets/vehiculos/vehicle_list_tile.dart';
import '../../widgets/vehiculos/service_detail_view.dart';

// Modelo de datos simple
class VehicleMock {
  final String id;
  final String plate;
  final String model;
  final String status;
  final String? activeServiceId;

  VehicleMock(this.id, this.plate, this.model, this.status, {this.activeServiceId});
}

// Datos de prueba
final List<VehicleMock> mockVehicles = [
  VehicleMock('1', 'ABC-1234', 'Toyota Hilux #04', 'WORKSHOP', activeServiceId: 'S-001'),
  VehicleMock('2', 'XYZ-5678', 'Ford Ranger #02', 'AVAILABLE'),
  VehicleMock('3', 'DEF-9012', 'Nissan Frontier #09', 'OCCUPIED'),
];

class VehicleServicePage extends StatefulWidget {
  const VehicleServicePage({super.key});

  @override
  State<VehicleServicePage> createState() => _VehicleServicePageState();
}

class _VehicleServicePageState extends State<VehicleServicePage> {
  VehicleMock? selectedVehicle;

  @override
  Widget build(BuildContext context) {
    // Verificamos si hay un vehículo seleccionado
    final bool hasSelected = selectedVehicle != null;
  
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      body: Row(
        children: [
          // PANEL IZQUIERDO: SE CONTRAE O SE OCULTA
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            // Si hay selección, su ancho es 0 o pequeño (aquí 80 para un menú tipo "mini")
            width: hasSelected ? 80 : 300, 
            child: Column(
              children: [
                // Botón de "Volver" cuando está contraído
                if (hasSelected)
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => setState(() => selectedVehicle = null),
                  ),
                
                Expanded(
                  child: ListView.builder(
                    itemCount: mockVehicles.length,
                    itemBuilder: (context, index) {
                      final v = mockVehicles[index];
                      
                      // Si está contraído, mostramos solo un icono, si está expandido, el tile completo
                      if (hasSelected) {
                        return IconButton(
                          icon: CircleAvatar(child: Text(v.model[0])),
                          onPressed: () => setState(() => selectedVehicle = v),
                        );
                      }
                      
                      return VehicleListTile(
                        model: v.model,
                        plate: v.plate,
                        status: v.status,
                        isSelected: selectedVehicle?.id == v.id,
                        onTap: () => setState(() => selectedVehicle = v),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // PANEL DERECHO: DETALLE (Ocupa todo el resto)
          Expanded(
            child: Container(
              color: Colors.white,
              child: selectedVehicle == null
                  ? const Center(child: Text("Selecciona un vehículo para ver detalles"))
                  : ServiceDetailView(
                      key: ValueKey(selectedVehicle!.id),
                      vehicle: selectedVehicle!,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}