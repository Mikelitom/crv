import 'package:crv_reprosisa/features/assets/presentation/providers/vehicle_list_notifier_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CatalogStats extends ConsumerWidget {
  final bool isVehiculo;
  const CatalogStats({super.key, required this.isVehiculo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleState = ref.watch(vehicleListProvider);

    // Datos reales del provider
    final int total = vehicleState.vehicles.length;
    final int enOperacion = vehicleState.vehicles.where((v) => v.isActive).length;
    final int enTaller = total - enOperacion;

    final labels = isVehiculo
        ? ["Total Vehículos", "En Operación", "En Taller"]
        : ["Total Prensas", "Activas", "Mantenimiento"];

    final icons = isVehiculo
        ? [Icons.inventory_2_outlined, Icons.local_shipping_outlined, Icons.build_circle_outlined]
        : [Icons.precision_manufacturing, Icons.settings_suggest, Icons.handyman_outlined];

    final values = isVehiculo
        ? [total.toString(), enOperacion.toString(), enTaller.toString()]
        : ["0", "0", "0"];

    return LayoutBuilder(builder: (context, constraints) {
      int crossAxisCount = constraints.maxWidth > 800 ? 3 : 1;

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          mainAxisExtent: 100,
        ),
        itemBuilder: (context, index) {
          return _StatCard(
            label: labels[index],
            value: values[index],
            icon: icons[index],
          );
        },
      );
    });
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: Color(0xFFFDECEA), shape: BoxShape.circle),
            child: Icon(icon, color: const Color(0xFFC62828), size: 24),
          ),
        ],
      ),
    );
  }
}
