import 'package:crv_reprosisa/features/catalogo/presentation/widgets/catalogo_stats.dart';
import 'package:crv_reprosisa/features/catalogo/presentation/widgets/vehicle_catalog_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../assets/presentation/providers/vehicle_list_notifier_provider.dart';

enum AssetType { vehiculo, prensa }

class GenericCatalogPage extends ConsumerStatefulWidget {
  final AssetType type;
  const GenericCatalogPage({super.key, required this.type});

  @override
  ConsumerState<GenericCatalogPage> createState() => _GenericCatalogPageState();
}

class _GenericCatalogPageState extends ConsumerState<GenericCatalogPage> {

  @override
  void initState() {
    super.initState();
    // Disparamos la carga de datos del catálogo al iniciar
    if (widget.type == AssetType.vehiculo) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(vehicleListProvider.notifier).loadVehicles();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isVehiculo = widget.type == AssetType.vehiculo;
    final String title = isVehiculo ? "Gestión de Vehículos" : "Gestión de Prensas";
    final IconData actionIcon = isVehiculo ? Icons.directions_car_filled : Icons.precision_manufacturing;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con estilo de Card
              _buildHeader(title, actionIcon),

              const SizedBox(height: 32),

              // Tarjetas de Estadísticas Dinámicas
              CatalogStats(isVehiculo: isVehiculo),

              const SizedBox(height: 40),

              const Text(
                "Listado de Catálogo",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Buscador Robusto
              _buildSearchBar(),

              const SizedBox(height: 32),

              // Lógica de Contenido: Lista real para vehículos, Placeholder para otros
              isVehiculo
                ? const VehicleCatalogList()
                : _buildEmptyPlaceholder("No hay prensas registradas", Icons.settings_suggest),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String title, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A1C1E))),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFC62828), borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: "Buscar en el catálogo...",
          prefixIcon: Icon(Icons.search, color: Color(0xFFC62828), size: 24),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget _buildEmptyPlaceholder(String message, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFECEFF1)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 80, color: const Color(0xFFFDECEA)),
          const SizedBox(height: 20),
          Text(message, style: const TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }
}
