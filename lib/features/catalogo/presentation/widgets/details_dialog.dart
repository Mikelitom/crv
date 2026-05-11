import 'package:flutter/material.dart';
import '../../data/models/vehicle_state_model.dart';

class VehicleDetailsDialog extends StatelessWidget {
  final VehicleStateModel vehicle;

  const VehicleDetailsDialog({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 450),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFFC62828),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_shipping, color: Colors.white, size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Placa: ${vehicle.plate}",
                          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                        Text(vehicle.isActive ? "UNIDAD EN OPERACIÓN" : "UNIDAD EN MANTENIMIENTO",
                          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11, letterSpacing: 1.2)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white)
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildPrimaryCard(
                    vehicle.isActive ? Icons.person_pin_rounded : Icons.build_circle,
                    vehicle.isActive ? "RESPONSABLE ASIGNADO" : "TALLER / SERVICIO",
                    vehicle.responsibleName,
                    Colors.black87
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(child: _buildSecondaryTile(
                        Icons.logout_rounded,
                        "HORA SALIDA",
                        vehicle.checkout != null
                          ? "${vehicle.checkout!.hour}:${vehicle.checkout!.minute.toString().padLeft(2,'0')}"
                          : "08:30 AM"
                      )),
                      const SizedBox(width: 12),
                      Expanded(child: _buildSecondaryTile(
                        Icons.phone_android,
                        "CONTACTO",
                        vehicle.isActive ? "662-123-4567" : "Taller Central"
                      )),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(child: _buildSecondaryTile(
                        Icons.map_rounded,
                        "UBICACIÓN ACTUAL",
                        vehicle.location ?? "Ruta Mina"
                      )),
                      const SizedBox(width: 12),
                      Expanded(child: _buildSecondaryTile(
                        Icons.shutter_speed_rounded,
                        "KM ACTUAL",
                        "${vehicle.mileage ?? 12450} KM"
                      )),
                    ],
                  ),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC62828),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text("CERRAR CONSULTA", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrimaryCard(IconData icon, String label, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFECEFF1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFC62828), size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: valueColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryTile(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFECEFF1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFFC62828).withOpacity(0.7)),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}