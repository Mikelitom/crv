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
    this.identifierTitle = "IDENTIFICADOR"
  });

  @override
  Widget build(BuildContext context) {
    // Filtramos los vehículos según la búsqueda
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
                duration: const Duration(milliseconds: 250),
                child: isLoading
                    ? const SizedBox(
                        height: 250,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : filtered.isEmpty
                    ? const SizedBox(
                        height: 250,
                        child: Center(
                          child: Text(
                            "No hay movimientos recientes",
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                        ),
                      )
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

  // --- MODO DESKTOP: TABLA ORIGINAL ---
  Widget _buildDesktopTable(List<AssetLastMovement> filtered) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(1.2),
        3: FlexColumnWidth(1.6),
        4: FlexColumnWidth(1.5),
        5: FlexColumnWidth(1.5),
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
                  _tableCell(_buildStateBadge(m.state)),
                  _tableCell(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('dd/MM/yyyy').format(m.eventDate),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          DateFormat('hh:mm a').format(m.eventDate),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _tableCell(Text(m.userName)),
                  _tableCell(_buildMovementBadge(m.movementType)),
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
      separatorBuilder: (_, __) => const Divider(height: 20),
      itemBuilder: (_, i) {
        final m = filtered[i];

        return Card(
          elevation: 0,
          color: Colors.grey.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  m.identifier,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(m.assetType, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _buildStateBadge(m.state)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildMovementBadge(m.movementType)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  m.userName,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('dd/MM/yyyy • hh:mm a').format(m.eventDate),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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

  Widget _tableCell(Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: child,
    );
  }
}
