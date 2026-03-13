import 'package:crv_reprosisa/features/activos/presentation/providers/press_list_notifier_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../press_catalog_list.dart';
import '../catalogo_stats.dart';
import '../../../../activos/presentation/notifiers/press_list_notifier.dart';


class PressCatalogPage extends ConsumerStatefulWidget {
  const PressCatalogPage({super.key});

  @override
  ConsumerState<PressCatalogPage> createState() => _PressCatalogPageState();
}

class _PressCatalogPageState extends ConsumerState<PressCatalogPage> {
  @override
  void initState() {
    super.initState();
    // DISPARA LA CARGA IGUAL QUE EN VEHÍCULOS
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(pressListProvider.notifier).loadPress();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              // STATS CON LÓGICA DE PRENSAS
              const CatalogStats(isVehiculo: false), 
              const SizedBox(height: 40),
              const Text(
                "Listado de Catálogo",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 32),
              
              // AQUÍ ESTABA EL ERROR: AHORA LLAMAMOS A LA TABLA REAL
              const PressCatalogList(), 
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
          const Text("Gestión de Prensas", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFC62828), borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.precision_manufacturing, color: Colors.white, size: 28),
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
          prefixIcon: Icon(Icons.search, color: Color(0xFFC62828)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}