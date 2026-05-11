import 'package:flutter/material.dart';

class PressDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> press;

  const PressDetailsDialog({super.key, required this.press});

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
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFFC62828),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.precision_manufacturing, color: Colors.white, size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ID: ${press['id']}",
                          style: const TextStyle(
                            color: Colors.white, 
                            fontSize: 22, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          press['estado'] == 'EN CURSO' ? "UNIDAD EN PRÉSTAMO" : "UNIDAD DISPONIBLE",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8), 
                            fontSize: 11, 
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildPrimaryCard(
                    Icons.account_circle_outlined,
                    "SOLICITANTE ASIGNADO",
                    press['sol'] ?? "SIN ASIGNAR",
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: _buildSecondaryTile(
                          Icons.calendar_today_outlined,
                          "FECHA PRÉSTAMO",
                          press['fecha'] ?? "---",
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSecondaryTile(
                          Icons.phone_android_outlined,
                          "CONTACTO",
                          press['contacto'] ?? "662-000-0000",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _buildSecondaryTile(
                          Icons.business_center_outlined, // CORREGIDO: Minúscula
                          "ÁREA DE USO",
                          press['area'] ?? "GENERAL",
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSecondaryTile(
                          Icons.event_available_outlined,
                          "RETORNO EXP.",
                          press['retorno'] ?? "PENDIENTE",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC62828),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "CERRAR CONSULTA",
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          letterSpacing: 1.1
                        ),
                      ),
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

  Widget _buildPrimaryCard(IconData icon, String label, String value) {
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
                Text(
                  label, 
                  style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)
                ),
                Text(
                  value, 
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)
                ),
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
          Text(
            label, 
            style: const TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}