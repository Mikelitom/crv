import 'package:crv_reprosisa/features/catalogo/presentation/widgets/press_catalog_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../activos/presentation/providers/vehicle_list_notifier_provider.dart';
import '../widgets/catalogo_stats.dart';
import '../widgets/vehicle_catalog_list.dart';

// 1. AGREGA ESTO AQUÍ (El enum que falta)
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
    // 2. Ahora AssetType.vehiculo ya no saldrá en rojo
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
              // HEADER (Título y Botón Rojo)
              _buildHeader(title, actionIcon),

              const SizedBox(height: 32),
              
              // STATS (Contadores dinámicos)
              CatalogStats(isVehiculo: isVehiculo), 

              const SizedBox(height: 40),
              
              const Text(
                "Listado de Catálogo",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A1C1E)),
              ),
              const SizedBox(height: 20),

              // BUSCADOR
              _buildSearchBar(),

              const SizedBox(height: 32),

              // TABLA DE DATOS REALES
              isVehiculo 
                ? const VehicleCatalogList() 
                : const PressCatalogList()
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
          Text(
            title, 
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A1C1E))
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFC62828), 
              borderRadius: BorderRadius.circular(14)
            ),
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
}