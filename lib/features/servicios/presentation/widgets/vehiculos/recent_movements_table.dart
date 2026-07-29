import 'package:crv_reprosisa/features/servicios/domain/entities/asset_last_movement.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecentMovementsTable extends StatelessWidget {
  final List<AssetLastMovement> movements;
  final String searchQuery; // Pasamos el buscador para filtrar aquí
  final bool isLoading;
  final String identifierTitle;

  const RecentMovementsTable({
    super.key,
    required this.movements,
    this.searchQuery = "",
    this.isLoading = false,
    this.identifierTitle = "IDENTIFICADOR",
  });

  @override
  Widget build(BuildContext context) {
    final filtered = movements.where((m) {
      return m.identifier.toLowerCase().contains(searchQuery.toLowerCase()) ||
          m.assetType.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 700;

        return Container(
          margin: const EdgeInsets.only(top: 24),
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Últimos movimientos",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: isLoading
                    ? const SizedBox(
                        height: 250,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFC62828),
                          ),
                        ),
                      )
                    : filtered.isEmpty
                    ? _buildEmptyState()
                    : isMobile
                    ? _buildMobileList(filtered)
                    : _buildDesktopTable(filtered),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return const SizedBox(
      height: 250,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "No hay movimientos recientes",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  // --- MODO DESKTOP: TABLA ORIGINAL ---
  Widget _buildDesktopTable(List<AssetLastMovement> filtered) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.0), // Serie
        1: FlexColumnWidth(1.8), // Activo
        2: FlexColumnWidth(1.2), // Estado
        3: FlexColumnWidth(
          1.8,
        ), // Fecha (Le damos más espacio para que no rompa)
        4: FlexColumnWidth(2.0), // Usuario
        5: FlexColumnWidth(1.4), // Movimiento
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade100),
          children:
              [
                    identifierTitle,
                    "ACTIVO",
                    "ESTADO",
                    "FECHA",
                    "USUARIO",
                    "MOVIMIENTO",
                  ]
                  .map(
                    (h) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        h,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
        ...filtered
            .take(10)
            .map(
              (m) => TableRow(
                children: [
                  _tableCell(
                    Text(
                      m.identifier,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  _tableCell(Text(m.assetType)),
                  _tableCell(
                    _buildStateBadge(m.state),
                    alignment: Alignment.center,
                  ), // Centrado para insignias
                  _tableCell(
                    SizedBox(
                      width: 110,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('dd/MM/yyyy').format(m.eventDate),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            DateFormat('hh:mm a').format(m.eventDate),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _tableCell(
                    Text(
                      m.userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  _tableCell(
                    _buildMovementBadge(m.movementType),
                    alignment: Alignment.center,
                  ), // Centrado para insignias
                ],
              ),
            ),
      ],
    );
  }

  // --- MODO MÓVIL: LISTA DE TARJETAS ---
  Widget _buildMobileList(List<AssetLastMovement> filtered) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filtered.take(10).length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final m = filtered[i];
        // Animación de entrada para cada tarjeta
        return AnimatedContainer(
          duration: Duration(milliseconds: 300 + (i * 100)),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    m.identifier,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      color: Color(0xFFC62828), // Rojo institucional
                    ),
                  ),
                  Text(
                    DateFormat('dd/MM/yy • hh:mm a').format(m.eventDate),
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
              Text(
                m.assetType,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),

              // Campos con etiquetas
              _buildMobileField("Estado:", _buildStateBadge(m.state)),
              const SizedBox(height: 8),
              _buildMobileField(
                "Movimiento:",
                _buildMovementBadge(m.movementType),
              ),

              const Divider(height: 20),

              Text(
                m.userName,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Widget auxiliar para alinear etiqueta y contenido en móvil
  Widget _buildMobileField(String label, Widget child) => Row(
    children: [
      SizedBox(
        width: 80,
        child: Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
      child,
    ],
  );

  String _translateState(String state) {
    switch (state.toUpperCase()) {
      case 'AVAILABLE':
        return 'Disponible';
      case 'OCCUPIED':
        return 'Ocupado';
      case 'WORKSHOP':
        return 'En taller';
      case 'IN_PROGRESS':
        return 'En proceso';
      case 'COMPLETED':
        return 'Completado';
      default:
        return state;
    }
  }

  Color _stateColor(String state) {
    switch (state.toUpperCase()) {
      case 'AVAILABLE':
        return Colors.green;
      case 'WORKSHOP':
        return Colors.orange;
      case 'OCCUPIED':
        return Colors.blue;
      case 'COMPLETED':
        return const Color(0xFFC62828);
      default:
        return Colors.grey;
    }
  }

  Widget _buildStateBadge(String state) {
    final color = _stateColor(state);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        _translateState(state),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildMovementBadge(String movement) {
    IconData icon;
    Color color;

    switch (movement) {
      case 'Servicio':
        icon = Icons.build;
        color = Colors.orange;
        break;

      case 'Informe':
        icon = Icons.description;
        color = Colors.blue;
        break;

      default:
        icon = Icons.swap_horiz;
        color = Colors.green;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            movement,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableCell(
    Widget child, {
    AlignmentGeometry alignment = Alignment.centerLeft,
  }) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 52,
      ), // Altura mínima fija para estandarizar las filas
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Align(alignment: alignment, child: child),
    );
  }
}
