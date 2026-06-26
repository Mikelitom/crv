import 'package:crv_reprosisa/features/servicios/domain/entities/v_service_order.dart';
import 'package:crv_reprosisa/features/servicios/presentation/widgets/vehiculos/vehicle_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/vehicle.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/service_providers.dart';

class ServiceDetailView extends ConsumerStatefulWidget {
  final Vehicle vehicle;

  const ServiceDetailView({super.key, required this.vehicle});

  @override
  ConsumerState<ServiceDetailView> createState() => _ServiceDetailViewState();
}

class _ServiceDetailViewState extends ConsumerState<ServiceDetailView> {
  @override
  void initState() {
    super.initState();
    // Cargamos los servicios apenas entra al detalle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(serviceListNotifierProvider.notifier)
          .loadServices(widget.vehicle.vehicleId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(serviceListNotifierProvider);

    return Column(
      children: [
        _buildHeader(),
        VehicleInfoCard(vehicle: widget.vehicle),
        const SizedBox(height: 24),
        Expanded(
          child: state.status == Status.loading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: _buildSection(
                              "Componentes",
                              Icons.engineering,
                              Colors.red,
                              _buildComponentesList(state.services),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildSection(
                              "Inspecciones",
                              Icons.history,
                              Colors.blue,
                              _buildInspeccionesList(),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildSection(
                              "Orden Abierta",
                              Icons.assignment,
                              Colors.orange,
                              _buildOrdenServicioCard(state.services),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildRecurrenciaSection(),
                  ],
                ),
        ),
      ],
    );
  }

  // --- MÉTODOS DE CONTENIDO (Ahora reciben la lista de servicios) ---

  Widget _buildComponentesList(List<ServiceOrder> services) {
    if (services.isEmpty) return const Text("Sin componentes registrados");
    // Aquí mapeas tus servicios reales a la vista
    return Column(
      children: services
          .map(
            (s) =>
                ListTile(title: Text(s.description), subtitle: Text(s.status)),
          )
          .toList(),
    );
  }

  Widget _buildOrdenServicioCard(List<ServiceOrder> services) {
    final activeOrder = services.where((s) => s.isActive).firstOrNull;
    if (activeOrder == null) return const Text("No hay orden activa");

    return Column(
      children: [
        Text(
          activeOrder.id,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // ref.read(serviceListNotifierProvider.notifier).completeItem(activeOrder.id);
          },
          child: const Text("COMPLETAR"),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Detalle de Unidad",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text("Exportar"),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC62828),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  // AQUÍ DISPARAS EL MODAL PARA CREAR POST /vehicle/service
                },
                icon: const Icon(Icons.add),
                label: const Text("NUEVA ORDEN"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    String title,
    IconData icon,
    Color color,
    Widget content,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(padding: const EdgeInsets.all(8.0), child: content),
        ],
      ),
    );
  }

  Widget _buildInspeccionesList() => Column(
    children: [
      ListTile(
        title: const Text("15/06/2026"),
        subtitle: const Text("Realizado por: M. Fajardo"),
        leading: const Icon(Icons.check_circle, color: Colors.green, size: 20),
      ),
    ],
  );

  Widget _buildRecurrenciaSection() {
    // Datos simulados (esto vendría de tu API)
    final incidencias = [
      {'name': 'Filtro de aceite', 'veces': 5},
      {'name': 'Balatas', 'veces': 3},
      {'name': 'Banda de accesorios', 'veces': 2},
    ];

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.trending_up, color: Colors.purple, size: 20),
              SizedBox(width: 8),
              Text(
                "Incidencias más recurrentes",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(),
          ...incidencias.map(
            (i) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        i['name'] as String,
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        "${i['veces']} veces",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: (i['veces'] as int) / 6,
                    backgroundColor: Colors.grey[100],
                    color: Colors.purple,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
