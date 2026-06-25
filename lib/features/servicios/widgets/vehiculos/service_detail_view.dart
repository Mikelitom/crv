import 'package:flutter/material.dart';
import 'package:crv_reprosisa/features/servicios/widgets/vehiculos/vehicle_info_card.dart';
import '../../page/vehiculos/vehicle_service_page.dart';

class ServiceDetailView extends StatelessWidget {
  final VehicleMock vehicle;

  const ServiceDetailView({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. HEADER (Título y botón de acción)
        _buildHeader(),

        // 2. TARJETA DE INFO (Doble columna y KPIs integrados)
        VehicleInfoCard(vehicle: vehicle),

        const SizedBox(height: 24),

        // 3. CUERPO DEL DASHBOARD (Secciones detalladas)
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Columna: Componentes
                  Expanded(
                    child: _buildSection(
                      "Componentes con atención",
                      Icons.engineering,
                      Colors.red,
                      _buildComponentesList(),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Columna: Inspecciones
                  Expanded(
                    child: _buildSection(
                      "Últimas inspecciones",
                      Icons.history,
                      Colors.blue,
                      _buildInspeccionesList(),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Columna: Orden Abierta
                  Expanded(
                    child: _buildSection(
                      "Orden de servicio abierta",
                      Icons.assignment,
                      Colors.orange,
                      _buildOrdenServicioCard(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- WIDGETS DE ESTRUCTURA ---

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

  // --- CONTENIDO DE SECCIONES ---

  Widget _buildComponentesList() {
    // Ejemplo de datos con contador de recurrencia
    final componentes = [
      {'name': 'Filtro de aceite', 'count': 3},
      {'name': 'Banda de accesorios', 'count': 1},
    ];

    return Column(
      children: componentes.map((c) {
        final bool isCritical = (c['count'] as int) >= 3;
        return ListTile(
          title: Text(c['name'] as String),
          subtitle: Text("Incidencias previas: ${c['count']}"),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isCritical ? Colors.red : Colors.orange,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              isCritical ? "CRÍTICO" : "ATENCIÓN",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
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

  Widget _buildOrdenServicioCard() {
    final String estado = "IN_PROGRESS"; // Esto vendría de tu API
    final Color colorEstado = estado == "PENDING" ? Colors.orange : Colors.blue;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "OS-2026-005",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: colorEstado.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                estado,
                style: TextStyle(
                  color: colorEstado,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text("Taller: Toyota Mérida | Apertura: 18/06/2026"),
        const SizedBox(height: 16),

        // Botones dinámicos según flujo
        Row(
          children: [
            if (estado == "PENDING")
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text("INICIAR"),
                ),
              )
            else
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text("COMPLETAR"),
                ),
              ),
          ],
        ),
        const Divider(height: 30),

        // Historial completado
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Historial reciente:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        ...List.generate(
          2,
          (index) => ListTile(
            dense: true,
            leading: const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 18,
            ),
            title: Text("OS-2026-00${index + 1}"),
            subtitle: const Text("Finalizada el 10/06/2026"),
          ),
        ),
      ],
    );
  }
}
