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

                /// TARJETAS
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

  /// TARJETA
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
        onTap: () => showDialog(context: context, builder: (context) => dialog),
      ),
    );
  }

  /// CONTENEDOR DE TABLAS
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

            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 25,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),

              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    const TabBar(
                      labelColor: Color(0xFFD32F2F),
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Color(0xFFD32F2F),
                      indicatorWeight: 3,
                      tabs: [
                        Tab(
                          icon: Icon(Icons.people_alt_rounded),
                          text: "Clientes",
                        ),
                        Tab(
                          icon: Icon(Icons.local_shipping_rounded),
                          text: "Vehículos",
                        ),
                        Tab(
                          icon: Icon(Icons.settings_suggest_rounded),
                          text: "Prensas",
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 400,
                      child: TabBarView(
                        children: [
                          /// CLIENTES
                          _buildStateTable(
                            clientState.status,
                            clientState.error,
                            _buildGenericTable<ClientsConveyor>(
                              clientCols,
                              clientState.clients,
                              (client) => DataRow(
                                cells: [
                                  DataCell(Text(client.id)),
                                  DataCell(Text(client.name)),
                                  DataCell(Text(client.company)),
                                  const DataCell(Icon(Icons.more_horiz)),
                                ],
                              ),
                            ),
                          ),

                          /// VEHICULOS
                          _buildStateTable(
                            vehicleState.status,
                            vehicleState.error,
                            _buildGenericTable<Vehicle>(
                              vehicleCols,
                              vehicleState.vehicles,
                              (vehicle) => DataRow(
                                cells: [
                                  DataCell(Text(vehicle.id)),
                                  DataCell(Text(vehicle.licensePlate)),
                                  DataCell(Text(vehicle.model)),
                                  const DataCell(Icon(Icons.more_horiz)),
                                ],
                              ),
                            ),
                          ),

                          /// PRENSAS
                          _buildStateTable(
                            pressState.status,
                            pressState.error,
                            _buildGenericTable<Press>(
                              pressCols,
                              pressState.press,
                              (press) => DataRow(
                                cells: [
                                  DataCell(Text(press.id)),
                                  DataCell(Text(press.serie)),
                                  DataCell(Text(press.type)),
                                  const DataCell(Icon(Icons.more_horiz)),
                                ],
                              ),
                            ),
                          ),
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

  /// SEARCH
  Widget _buildSearchBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: "Buscar registros...",
          prefixIcon: Icon(Icons.search_rounded, color: Color(0xFFD32F2F)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  /// TABLA GENERICA
  Widget _buildGenericTable<T>(
    List<DataColumn> columns,
    List<T> items,
    DataRow Function(T) buildRow,
  ) {
    if (items.isEmpty) {
      return const Center(
        child: Text(
          "No hay registros disponibles",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(columns: columns, rows: items.map(buildRow).toList()),
    );
  }

  /// LOADING / ERROR
  Widget _buildStateTable(Status status, String? error, Widget table) {
    if (status == Status.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (status == Status.error) {
      return Center(child: Text(error ?? "Error"));
    }

    return table;
  }

  /// COLUMNAS
  List<DataColumn> get clientCols => const [
    DataColumn(label: Text('ID')),
    DataColumn(label: Text('Nombre')),
    DataColumn(label: Text('Compañía')),
    DataColumn(label: Text('Acciones')),
  ];

  List<DataColumn> get vehicleCols => const [
    DataColumn(label: Text('ID')),
    DataColumn(label: Text('Placas')),
    DataColumn(label: Text('Modelo')),
    DataColumn(label: Text('Acciones')),
  ];

  List<DataColumn> get pressCols => const [
    DataColumn(label: Text('ID')),
    DataColumn(label: Text('Serie')),
    DataColumn(label: Text('Tipo')),
    DataColumn(label: Text('Acciones')),
  ];
}
