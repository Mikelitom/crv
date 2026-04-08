import 'package:crv_reprosisa/features/assets/domain/entities/clients_conveyor.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/press.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/vehicle.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/client_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/vehicle_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/press_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/dialogs/create_client_dialog.dart';
import 'package:crv_reprosisa/features/assets/presentation/dialogs/create_vehicle_dialog.dart';
import 'package:crv_reprosisa/features/assets/presentation/dialogs/create_press_dialog.dart';
import 'package:crv_reprosisa/features/assets/presentation/widgets/asset_action_card.dart';
import 'package:crv_reprosisa/features/dashboard/presentation/widgets/header.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AssetsAdminPage extends ConsumerStatefulWidget {
  const AssetsAdminPage({super.key});

  @override
  ConsumerState<AssetsAdminPage> createState() => _AssetsAdminPageState();
}

class _AssetsAdminPageState extends ConsumerState<AssetsAdminPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(clientListProvider.notifier).loadClients();
      ref.read(vehicleListProvider.notifier).loadVehicles();
      ref.read(pressListProvider.notifier).loadPress();
    });
  }

  @override
  Widget build(BuildContext context) {
    final clientState = ref.watch(clientListProvider);
    final vehicleState = ref.watch(vehicleListProvider);
    final pressState = ref.watch(pressListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth = constraints.maxWidth;
          bool isDesktop = maxWidth > 900;
          double spacing = 20.0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomHeader(
                  title: "Activos Corporativos",
                  actionIcon: Icons.business_center_rounded,
                ),

                const SizedBox(height: 32),

                const Text(
                  "Crear Nuevo",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1A1C1E),
                  ),
                ),

                const SizedBox(height: 24),

                /// TARJETAS DE ACCIÓN SUPERIOR
                isDesktop
                    ? IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildAdaptedCard(
                                context,
                                "Nuevo Cliente",
                                Icons.group_add_rounded,
                                const CreateClientDialog(),
                              ),
                            ),
                            SizedBox(width: spacing),
                            Expanded(
                              child: _buildAdaptedCard(
                                context,
                                "Nuevo Vehículo",
                                Icons.directions_car_filled_rounded,
                                const CreateVehicleDialog(),
                              ),
                            ),
                            SizedBox(width: spacing),
                            Expanded(
                              child: _buildAdaptedCard(
                                context,
                                "Nueva Prensa",
                                Icons.precision_manufacturing_rounded,
                                const CreatePressDialog(),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Wrap(
                        spacing: spacing,
                        runSpacing: spacing,
                        children: [
                          _buildAdaptedCard(
                            context,
                            "Nuevo Cliente",
                            Icons.group_add_rounded,
                            const CreateClientDialog(),
                            customWidth: maxWidth,
                          ),
                          _buildAdaptedCard(
                            context,
                            "Nuevo Vehículo",
                            Icons.directions_car_filled_rounded,
                            const CreateVehicleDialog(),
                            customWidth: maxWidth,
                          ),
                          _buildAdaptedCard(
                            context,
                            "Nueva Prensa",
                            Icons.precision_manufacturing_rounded,
                            const CreatePressDialog(),
                            customWidth: maxWidth,
                          ),
                        ],
                      ),

                const SizedBox(height: 48),

                const Text(
                  "Registros Existentes",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1A1C1E),
                  ),
                ),

                const SizedBox(height: 20),

                _buildCenteredTableContainer(
                  context,
                  clientState,
                  vehicleState,
                  pressState,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAdaptedCard(
    BuildContext context,
    String title,
    IconData icon,
    Widget dialog, {
    double? customWidth,
  }) {
    return SizedBox(
      width: customWidth,
      child: ActionCardActivo(
        title: title,
        description: "Registrar $title en el sistema",
        icon: icon,
        onTap: () async {
          final result = await showDialog(
            context: context,
            builder: (context) => dialog,
          );

          if (!context.mounted) return;

          if (result == true) {
            _showSuccessSnackBar(context);
          }
        },
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
          child: Row(
            children: [
              Container(width: 4, height: 20, color: Colors.green),
              const SizedBox(width: 12),
              const Icon(Icons.check_circle_outline, color: Colors.green),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  "Registro exitoso",
                  style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenteredTableContainer(
    BuildContext context,
    dynamic clientState,
    dynamic vehicleState,
    dynamic pressState,
  ) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1600),
        child: Column(
          children: [
            _buildSearchBar(),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    const TabBar(
                      labelColor: Color(0xFFC62828),
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Color(0xFFC62828),
                      indicatorWeight: 4,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      tabs: [
                        Tab(icon: Icon(Icons.people_alt_rounded), text: "Clientes"),
                        Tab(icon: Icon(Icons.local_shipping_rounded), text: "Vehículos"),
                        Tab(icon: Icon(Icons.settings_suggest_rounded), text: "Prensas"),
                      ],
                    ),

                    SizedBox(
                      height: 550,
                      child: TabBarView(
                        children: [
                          _buildStateTable(clientState.status, clientState.error, _buildClientTable(clientState.clients)),
                          _buildStateTable(vehicleState.status, vehicleState.error, _buildVehicleTable(vehicleState.vehicles)),
                          _buildStateTable(pressState.status, pressState.error, _buildPressTable(pressState.press)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15)],
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: "Buscar registros...",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
          prefixIcon: Icon(Icons.search_rounded, color: Color(0xFFC62828)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget _buildClientTable(List<ClientsConveyor> clients) {
    return _buildGenericTable(
      columns: ['ID (UUID)', 'NOMBRE COMPLETO', 'COMPAÑÍA', 'ACCIONES'],
      rows: clients.map((client) => DataRow(cells: [
        DataCell(Text(client.id.length > 8 ? "${client.id.substring(0, 8)}..." : client.id, style: const TextStyle(color: Colors.grey, fontSize: 12))),
        DataCell(Text(client.name, style: const TextStyle(fontWeight: FontWeight.w600))),
        DataCell(Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
          child: Text(client.company.toUpperCase(), style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold, fontSize: 10)),
        )),
        DataCell(_buildActionsMenu(
          onEdit: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdateClientDialog(client: client))),
          onDelete: () {},
        )),
      ])).toList(),
    );
  }

  Widget _buildVehicleTable(List<Vehicle> vehicles) {
    return _buildGenericTable(
      columns: ['ID', 'PLACAS', 'MODELO / MARCA', 'ACCIONES'],
      rows: vehicles.map((v) => DataRow(cells: [
        DataCell(Text(v.id.substring(0, 5), style: const TextStyle(color: Colors.grey))),
        DataCell(Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(border: Border.all(color: Colors.black87, width: 1.5), borderRadius: BorderRadius.circular(6), color: const Color(0xFFF1F1F1)),
          child: Text(v.licensePlate, style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2, color: Colors.black)),
        )),
        DataCell(Text(v.model, style: const TextStyle(fontWeight: FontWeight.w500))),
        DataCell(_buildActionsMenu(onEdit: () {}, onDelete: () {})),
      ])).toList(),
    );
  }

  Widget _buildPressTable(List<Press> presses) {
    return _buildGenericTable(
      columns: ['ID', 'NÚMERO DE SERIE', 'TIPO DE PRENSA', 'ACCIONES'],
      rows: presses.map((p) => DataRow(cells: [
        DataCell(Text(p.id.substring(0, 5), style: const TextStyle(color: Colors.grey))),
        DataCell(Text(p.serie, style: const TextStyle(color: Color(0xFFC62828), fontWeight: FontWeight.bold))),
        DataCell(Text(p.type, style: const TextStyle(fontWeight: FontWeight.w500))),
        DataCell(_buildActionsMenu(
          onEdit: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdatePressDialog(press: p))),
          onDelete: () {},
        )),
      ])).toList(),
    );
  }

  /// MÉTODO GENÉRICO QUE FUERZA EL ANCHO TOTAL
  Widget _buildGenericTable({required List<String> columns, required List<DataRow> rows}) {
    if (rows.isEmpty) return const Center(child: Text("No hay registros disponibles", style: TextStyle(color: Colors.grey)));
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth), // FUERZA ANCHO TOTAL
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.grey.shade100),
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(const Color(0xFFF8F9FA)),
                dataRowMaxHeight: 70,
                headingRowHeight: 56,
                horizontalMargin: 24,
                columnSpacing: 20, // Espaciado base entre columnas
                columns: columns.map((c) => DataColumn(
                  label: Text(
                    c, 
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: Colors.blueGrey, letterSpacing: 0.5)
                  )
                )).toList(),
                rows: rows,
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _buildActionsMenu({required VoidCallback onEdit, required VoidCallback onDelete}) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_horiz_rounded, color: Colors.grey),
      offset: const Offset(0, 45),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onSelected: (val) {
        if (val == 'edit') onEdit();
        if (val == 'delete') onDelete();
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(children: [Icon(Icons.edit_outlined, size: 20, color: Colors.blue), SizedBox(width: 12), Text("Editar")]),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(children: [Icon(Icons.delete_outline_rounded, size: 20, color: Colors.red), SizedBox(width: 12), Text("Eliminar", style: TextStyle(color: Colors.red))]),
        ),
      ],
    );
  }

  Widget _buildStateTable(Status status, String? error, Widget table) {
    if (status == Status.loading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFFC62828), strokeWidth: 3));
    }

    if (status == Status.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.red, size: 40),
            const SizedBox(height: 12),
            Text(error ?? "Error al sincronizar datos", style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600)),
          ],
        ),
      );
    }

    return table;
  }
}