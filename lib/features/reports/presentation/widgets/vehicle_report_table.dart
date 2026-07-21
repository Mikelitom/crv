import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/servicios/presentation/utils/pdf_report_processor.dart';
import 'package:crv_reprosisa/features/reports/presentation/widgets/base_report_table.dart';
import 'package:crv_reprosisa/features/reports/data/models/vehicle_history_model.dart';
import 'package:crv_reprosisa/features/assets/presentation/pages/client_pdf_viewer_page.dart';
import 'package:printing/printing.dart';

const Color kPrimaryRed = Color(0xFFC62828);
const Color kCardBg = Colors.white;
const Color kDarkText = Color(0xFF1A1C1E);
const Color kGreyText = Color(0xFF757575);

class VehicleReportTable extends ConsumerStatefulWidget {
  final List<dynamic> reports;
  final bool isAdmin;

  const VehicleReportTable({
    super.key,
    required this.reports,
    required this.isAdmin,
  });

  @override
  ConsumerState<VehicleReportTable> createState() => _VehicleReportTableState();
}

class _VehicleReportTableState extends ConsumerState<VehicleReportTable> {
  String searchQuery = '';
  String selectedStatus = 'Todos';

  // Mapa para guardar la versión seleccionada actualmente por cada reporte usando el identificador base
  final Map<String, VehicleHistoryModel> _selectedVersions = {};

  String _translateStatus(String state) {
    switch (state.toUpperCase()) {
      case 'IN_REVISION':
      case 'EN REVISIÓN':
      case 'PENDING':
      case 'PENDIENTE':
        return 'En revisión';
      case 'COMPLETED':
      case 'COMPLETADO':
      case 'ACCEPTED':
      case 'ACEPTADO':
        return 'Aprobado';
      case 'REJECTED':
      case 'RECHAZADO':
      case 'DEVUELTO':
        return 'Regresado';
      default:
        return 'Aprobado';
    }
  }

  Color _getStatusColor(String state) {
    final translated = _translateStatus(state);
    if (translated == 'En revisión') {
      return Colors.amber.shade700;
    } else if (translated == 'Regresado') {
      return Colors.purple;
    }
    return Colors.green;
  }

  Widget statusChip(String state) {
    final translated = _translateStatus(state);
    final color = _getStatusColor(state);
    IconData icon = Icons.check_circle_outlined;

    if (translated == 'En revisión') {
      icon = Icons.access_time_rounded;
    } else if (translated == 'Regresado') {
      icon = Icons.keyboard_return;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            translated,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // Selector de versión compacto integrado en el título con formato v1, v2 y salto de línea seguro
  Widget _buildVersionSelector(BuildContext context, VehicleHistoryModel currentItem, List<VehicleHistoryModel> allReports) {
    final versiones = allReports.where((i) => i.reportId == currentItem.reportId).toList()
      ..sort((a, b) => b.inspectionDate.compareTo(a.inspectionDate));

    final versionIndex = versiones.indexWhere((v) => v.versionId == currentItem.versionId);
    final versionNumber = versionIndex != -1 ? versiones.length - versionIndex : (currentItem.versionNumber > 0 ? currentItem.versionNumber : 1);

    if (versiones.length <= 1) {
      return Text(
        "Placa: ${currentItem.plate} (v$versionNumber)",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: kDarkText,
        ),
      );
    }

    return PopupMenuButton<VehicleHistoryModel>(
      padding: EdgeInsets.zero,
      tooltip: "Cambiar versión",
      offset: const Offset(0, 30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.white,
      surfaceTintColor: Colors.white,
      onSelected: (selectedVersion) {
        setState(() {
          _selectedVersions[currentItem.reportId] = selectedVersion;
        });
      },
      itemBuilder: (context) {
        return List.generate(versiones.length, (idx) {
          final v = versiones[idx];
          final vNum = versiones.length - idx;
          final isSelected = v.versionId == currentItem.versionId;
          return PopupMenuItem(
            value: v,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.directions_car,
                  size: 16,
                  color: isSelected ? kPrimaryRed : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  "v$vNum • Folio: ${v.folio}",
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? kPrimaryRed : kDarkText,
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.check, size: 14, color: Colors.green),
                ],
              ],
            ),
          );
        });
      },
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 2,
        runSpacing: 2,
        children: [
          Text(
            "Placa: ${currentItem.plate} (v$versionNumber)",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: kDarkText,
            ),
          ),
          const Icon(Icons.arrow_drop_down, size: 18, color: kPrimaryRed),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allReports = widget.reports
        .where((r) => r is VehicleHistoryModel)
        .cast<VehicleHistoryModel>()
        .toList();

    // Agrupamos por reportId para mostrar la versión más reciente por defecto o la seleccionada
    final Map<String, VehicleHistoryModel> uniqueMap = {};
    for (var item in allReports) {
      if (!uniqueMap.containsKey(item.reportId) ||
          item.inspectionDate.isAfter(uniqueMap[item.reportId]!.inspectionDate)) {
        uniqueMap[item.reportId] = item;
      }
    }

    final activeReports = uniqueMap.entries.map((entry) {
      return _selectedVersions[entry.key] ?? entry.value;
    }).toList();

    // Aplicar buscador y filtros de estado
    final filteredReports = activeReports.where((item) {
      final matchesSearch = searchQuery.isEmpty ||
          item.folio.toLowerCase().contains(searchQuery.toLowerCase()) ||
          item.plate.toLowerCase().contains(searchQuery.toLowerCase()) ||
          item.responsibleName.toLowerCase().contains(searchQuery.toLowerCase());

      final translatedState = _translateStatus(item.state);
      final matchesStatus = selectedStatus == 'Todos' || translatedState == selectedStatus;

      return matchesSearch && matchesStatus;
    }).toList();

    final totalCount = allReports.length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contador compacto con estilo exacto de tarjeta cuadrada requerida
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: SizedBox(
                width: 260,
                child: _AnimatedStatCard(
                  value: "$totalCount",
                  label: "Total Registrados",
                  icon: Icons.folder_open,
                  color: kPrimaryRed,
                ),
              ),
            ),

            // Barra de búsqueda y filtros
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    child: TextField(
                      onChanged: (val) => setState(() => searchQuery = val),
                      decoration: InputDecoration(
                        hintText: "Buscar por folio, placa, responsable...",
                        hintStyle: const TextStyle(fontSize: 12, color: kGreyText),
                        prefixIcon: const Icon(Icons.search, size: 18, color: kPrimaryRed),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: kPrimaryRed, width: 1.5),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedStatus,
                        icon: const Icon(Icons.keyboard_arrow_down, size: 18, color: kPrimaryRed),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: kDarkText),
                        items: ['Todos', 'En revisión', 'Aprobado', 'Regresado'].map((status) {
                          return DropdownMenuItem(value: status, child: Text("Estado: $status"));
                        }).toList(),
                        onChanged: (val) => setState(() => selectedStatus = val ?? 'Todos'),
                      ),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => setState(() {
                      searchQuery = '';
                      selectedStatus = 'Todos';
                      _selectedVersions.clear();
                    }),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kPrimaryRed,
                      side: BorderSide(color: kPrimaryRed.withValues(alpha: 0.4)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                    icon: const Icon(Icons.filter_alt_off_outlined, size: 16, color: kPrimaryRed),
                    label: const Text("Limpiar filtros", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(bottom: 14.0, left: 4.0),
              child: Text(
                "Historial de Reportes de Vehículos",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: kDarkText,
                  letterSpacing: -0.5,
                ),
              ),
            ),

            if (isMobile)
              _buildMobileView(context, ref, filteredReports, allReports)
            else
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BaseTable(
                    columns: const [
                      "VEHÍCULO",
                      "RESPONSABLE",
                      "FECHA",
                      "ESTADO",
                      "ACCIONES",
                    ],
                    rows: filteredReports.map((item) {
                      final dynamicIconColor = _getStatusColor(item.state);

                      return DataRow(
                        cells: [
                          DataCell(
                            SizedBox(
                              width: 230,
                              child: Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: dynamicIconColor.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.directions_car,
                                        color: dynamicIconColor,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _buildVersionSelector(context, item, allReports),
                                        Text(
                                          "Folio: ${item.folio}",
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: kGreyText,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          DataCell(
                            Row(
                              children: [
                                Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: kPrimaryRed.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.person_outline, size: 16, color: kPrimaryRed),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item.responsibleName,
                                    style: const TextStyle(fontWeight: FontWeight.w600, color: kDarkText, fontSize: 12.5),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DataCell(
                            Text(
                              item.inspectionDate.toString().split(' ')[0],
                              style: const TextStyle(color: kDarkText, fontWeight: FontWeight.w500, fontSize: 12),
                            ),
                          ),
                          DataCell(statusChip(item.state)),
                          DataCell(
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert, size: 22, color: kGreyText),
                              color: Colors.white,
                              surfaceTintColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: Colors.grey.shade200),
                              ),
                              onSelected: (value) {
                                if (value == 'view') {
                                  _handleView(context, ref, item);
                                } else if (value == 'print') {
                                  _handlePrint(context, ref, item);
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'view',
                                  child: Row(
                                    children: [
                                      Icon(Icons.visibility, color: Colors.blue, size: 18),
                                      SizedBox(width: 8),
                                      Text('Ver PDF'),
                                    ],
                                  ),
                                ),
                                if (widget.isAdmin)
                                  const PopupMenuItem(
                                    value: 'print',
                                    child: Row(
                                      children: [
                                        Icon(Icons.print, color: kPrimaryRed, size: 18),
                                        SizedBox(width: 8),
                                        Text('Imprimir'),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildMobileView(
    BuildContext context,
    WidgetRef ref,
    List<VehicleHistoryModel> filteredReports,
    List<VehicleHistoryModel> allReports,
  ) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredReports.length,
      itemBuilder: (context, index) {
        final item = filteredReports[index];
        final dateStr = item.inspectionDate.toString().split(' ')[0];
        final dynamicIconColor = _getStatusColor(item.state);
        final inspectorInitial = item.responsibleName.isNotEmpty ? item.responsibleName[0].toUpperCase() : 'R';

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: dynamicIconColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.directions_car,
                            color: dynamicIconColor,
                            size: 22,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "VEHÍCULO",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 2),
                            _buildVersionSelector(context, item, allReports),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 54.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Folio: ${item.folio}",
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        statusChip(item.state),
                      ],
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: kPrimaryRed.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        inspectorInitial,
                        style: const TextStyle(color: kPrimaryRed, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "RESPONSABLE",
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                        Text(
                          item.responsibleName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.5,
                            color: Colors.black87,
                          ),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        "FECHA",
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      Text(
                        dateStr,
                        style: const TextStyle(fontSize: 11.5, color: Colors.black87, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Opciones de gestión",
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 22, color: Colors.grey),
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    onSelected: (value) {
                      if (value == 'view') {
                        _handleView(context, ref, item);
                      } else if (value == 'print') {
                        _handlePrint(context, ref, item);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'view',
                        child: Row(
                          children: [
                            Icon(Icons.visibility, color: Colors.blue, size: 18),
                            SizedBox(width: 8),
                            Text('Ver PDF'),
                          ],
                        ),
                      ),
                      if (widget.isAdmin)
                        const PopupMenuItem(
                          value: 'print',
                          child: Row(
                            children: [
                              Icon(Icons.print, color: kPrimaryRed, size: 18),
                              SizedBox(width: 8),
                              Text('Imprimir'),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleView(
    BuildContext context,
    WidgetRef ref,
    VehicleHistoryModel item,
  ) async {
    final data = await PdfReportProcessor.generatePdfFromVersionId(
      ref,
      item.versionId,
    );

    if (data == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No se pudo generar la vista previa")),
        );
      }
      return;
    }

    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ClientPdfViewerPage(
            folio: item.folio,
            pdfGenerator: () async => data,
          ),
        ),
      );
    }
  }

  Future<void> _handlePrint(
    BuildContext context,
    WidgetRef ref,
    VehicleHistoryModel item,
  ) async {
    final data = await PdfReportProcessor.generatePdfFromVersionId(
      ref,
      item.versionId,
    );

    if (data != null) {
      await Printing.layoutPdf(onLayout: (_) async => data);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No se pudo generar el documento para impresión"),
          ),
        );
      }
    }
  }
}

class _AnimatedStatCard extends StatefulWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _AnimatedStatCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  State<_AnimatedStatCard> createState() => _AnimatedStatCardState();
}

class _AnimatedStatCardState extends State<_AnimatedStatCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isHovered ? const Color(0xFFFAFAFA) : kCardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: isHovered
                  ? widget.color.withValues(alpha: 0.15)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: isHovered ? 18 : 10,
              offset: Offset(0, isHovered ? 6 : 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isHovered ? widget.color : kGreyText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.value,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: kDarkText,
                      letterSpacing: -1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: isHovered ? widget.color : widget.color.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.icon,
                color: isHovered ? Colors.white : widget.color,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}