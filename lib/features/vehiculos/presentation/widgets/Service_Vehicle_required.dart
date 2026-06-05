import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/vehicle_inspection_provider.dart';

class VehicleServiceRequired extends ConsumerStatefulWidget {
  const VehicleServiceRequired({super.key});

  @override
  ConsumerState<VehicleServiceRequired> createState() =>
      _VehicleServiceRequiredState();
}

class _VehicleServiceRequiredState
    extends ConsumerState<VehicleServiceRequired> {
  late final TextEditingController _observationsController;

  @override
  void initState() {
    super.initState();

    final state = ref.read(vehicleInspectionProvider);

    _observationsController = TextEditingController(
      text: state.serviceObservations,
    );
  }

  @override
  void dispose() {
    _observationsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryRed = Color(0xFFC62828);

    final state = ref.watch(vehicleInspectionProvider);
    final notifier = ref.read(vehicleInspectionProvider.notifier);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Servicio",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: Color(0xFF1A1C1E),
            ),
          ),
          const Text(
            "Condiciones del servicio requerido",
            style: TextStyle(fontSize: 13, color: Color(0xFF5F6368)),
          ),
          const SizedBox(height: 16),

          const Text(
            "Requiere Servicio",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Color(0xFF444444),
            ),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              _buildOption(
                label: "Sí",
                isSelected: state.requiresService,
                onTap: () => notifier.toggleService(true),
                activeColor: primaryRed,
              ),
              const SizedBox(width: 24),
              _buildOption(
                label: "No",
                isSelected: !state.requiresService,
                onTap: () => notifier.toggleService(false),
                activeColor: primaryRed,
              ),
            ],
          ),

          const SizedBox(height: 20),

          const Text(
            "Observaciones",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Color(0xFF444444),
            ),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: _observationsController,
            maxLines: 2,
            style: const TextStyle(fontSize: 14),
            onChanged: notifier.updateServiceObservations,
            decoration: InputDecoration(
              hintText: "Escriba aquí las observaciones del servicio...",
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
              filled: true,
              fillColor: const Color(0xFFF8F9FB),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFDDE1E6)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: primaryRed, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required Color activeColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: isSelected ? activeColor : Colors.grey.shade400,
                width: 2,
              ),
              color: isSelected
                  ? activeColor.withOpacity(0.05)
                  : Colors.transparent,
            ),
            child: isSelected
                ? Center(child: Icon(Icons.check, size: 12, color: activeColor))
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? const Color(0xFF1A1C1E)
                  : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

