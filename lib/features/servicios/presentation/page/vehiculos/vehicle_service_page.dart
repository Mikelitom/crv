import 'package:crv_reprosisa/features/assets/presentation/providers/vehicle_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:crv_reprosisa/features/servicios/presentation/widgets/vehiculos/service_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/vehicle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VehicleServicePage extends ConsumerStatefulWidget {
  const VehicleServicePage({super.key});

  @override
  ConsumerState<VehicleServicePage> createState() => _VehicleServicePageState();
}

class _VehicleServicePageState extends ConsumerState<VehicleServicePage> {
  Vehicle? selectedVehicle; // Cambiamos de VehicleMock a tu clase Vehicle real
  bool isPanelOpen = true;

  @override
  void initState() {
    super.initState();
    // Cargamos los vehículos al entrar a la página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(vehicleListProvider.notifier).loadVehicles();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Escuchamos el estado del provider
    final state = ref.watch(vehicleListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      body: Stack(
        children: [
          // PANEL DERECHO: Detalle
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: selectedVehicle == null
                  ? const Center(child: Text("Selecciona un activo"))
                  : ServiceDetailView(key: ValueKey(selectedVehicle!.vehicleId), vehicle: selectedVehicle!),
            ),
          ),

          // PANEL IZQUIERDO: Flotante
          if (isPanelOpen)
            Positioned(
              left: 16, top: 16, bottom: 80, width: 350,
              child: Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)]),
                child: Column(
                  children: [
                    Padding(padding: const EdgeInsets.all(16), child: TextField(decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: "Buscar...", border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))))),
                    Expanded(
                      child: state.status == Status.loading 
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            itemCount: state.vehicles.length,
                            itemBuilder: (context, index) {
                              final v = state.vehicles[index];
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedVehicle = v;
                                    isPanelOpen = false;
                                  });
                                },
                                child: _buildCompactVehicleTile(v, selectedVehicle?.vehicleId == v.vehicleId),
                              );
                            },
                          ),
                    ),
                  ],
                ),
              ),
            ),
          
          // BOTÓN FLOTANTE
          Positioned(
            left: 16, bottom: 16,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              elevation: 4,
              onPressed: () => setState(() => isPanelOpen = !isPanelOpen),
              child: Icon(isPanelOpen ? Icons.close : Icons.list, color: const Color(0xFFC62828)),
            ),
          ),
        ],
      ),
    );
  }

  // Ajustado para tu modelo real
  Widget _buildCompactVehicleTile(Vehicle v, bool isSelected) {
    Color statusColor = v.operationState == "WORKSHOP" ? Colors.orange : Colors.blue;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: isSelected ? Colors.red.withOpacity(0.05) : Colors.transparent, border: Border(bottom: BorderSide(color: Colors.grey[200]!))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [const Icon(Icons.directions_car, size: 16), const SizedBox(width: 8), Text(v.plate, style: const TextStyle(fontWeight: FontWeight.bold))]),
            _buildCompactBadge(v.operationState, statusColor),
          ]),
          Text("${v.brand} ${v.model}", style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCompactBadge(String status, Color color) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)), child: Text(status, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)));
  }
}