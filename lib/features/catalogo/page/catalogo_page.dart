import 'package:flutter/material.dart';
import '../widgets/catalogo_stats.dart';

enum AssetType { vehiculo, prensa }

class GenericCatalogPage extends StatelessWidget {
  final AssetType type;
  const GenericCatalogPage({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final bool isVehiculo = type == AssetType.vehiculo;
    final String title = isVehiculo ? "Gestión de Vehículos" : "Gestión de Prensas";
    final IconData actionIcon = isVehiculo ? Icons.directions_car_filled : Icons.precision_manufacturing;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32), // Más espacio general
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER ROBUSTO (Igual a Usuarios)
              Container(
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
                      style: const TextStyle(
                        fontSize: 24, 
                        fontWeight: FontWeight.bold, 
                        color: Color(0xFF1A1C1E)
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC62828), 
                        borderRadius: BorderRadius.circular(14)
                      ),
                      child: Icon(actionIcon, color: Colors.white, size: 28),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              
              // Los Stats que ahora sí se ven grandes
              CatalogStats(isVehiculo: isVehiculo), 

              const SizedBox(height: 40),
              
              const Text(
                "Listado de Catálogo",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Buscador de buen tamaño (56px de alto)
              Container(
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
                ),
                child: TextField(
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: "Buscar en el catálogo...",
                    prefixIcon: const Icon(Icons.search, color: Color(0xFFC62828), size: 24),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Contenedor de la tabla proporcional
              _buildTableContainer(isVehiculo),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableContainer(bool isVehiculo) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFECEFF1)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 100),
        child: Center(
          child: Column(
            children: [
              Icon(
                isVehiculo ? Icons.directions_car_outlined : Icons.settings_suggest, 
                size: 80, 
                color: const Color(0xFFFDECEA)
              ),
              const SizedBox(height: 20),
              Text(
                isVehiculo ? "No hay vehículos registrados" : "No hay prensas registradas", 
                style: const TextStyle(color: Colors.grey, fontSize: 16)
              ),
            ],
          ),
        ),
      ),
    );
  }
}