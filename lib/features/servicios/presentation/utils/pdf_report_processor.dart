import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:crv_reprosisa/features/assets/domain/entities/vehicle_report_detail_entity.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/vehicle_report_detail.dart';
import 'package:crv_reprosisa/core/utils/SGC-PO-MT-01-FO-03-VEHICLE.dart';

class PdfReportProcessor {
  
  static Future<Uint8List?> generatePdfFromVersionId(
    WidgetRef ref, 
    String versionId
  ) async {
    try {
      // 1. Obtener los datos usando el provider de estado (el que ya tienes)
      final notifier = ref.read(vehicleReportDetailProvider.notifier);
      await notifier.fetchDetail(versionId);
      
      final state = ref.read(vehicleReportDetailProvider);
      
      if (state.error != null || state.data == null) {
        debugPrint("Error o datos nulos: ${state.error}");
        return null;
      }

      final data = state.data!;

      // 2. Descargar imágenes necesarias
      for (var ans in data.answers) {
        if (ans.evidencePaths.isNotEmpty) {
          ans.evidenceBytes = await _downloadImage(ans.evidencePaths[0]);
        }
      }

      // 3. Mapear y generar
      final pdfData = _mapEntityToPdfMap(data);
      return await VehiculoPdfGenerator.generateEsqueleto(pdfData);
      
    } catch (e) {
      debugPrint("Error fatal en procesamiento PDF: $e");
      return null;
    }
  }

  static Future<Uint8List?> _downloadImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      return response.statusCode == 200 ? response.bodyBytes : null;
    } catch (_) {
      return null;
    }
  }

  static Map<String, dynamic> _mapEntityToPdfMap(VehicleReportDetailEntity data) {
    Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var ans in data.answers) {
      String code = ans.optionName.toLowerCase();
      String status = "UNKNOWN";
      if (code.contains("buen")) status = "GOOD";
      else if (code.contains("mal")) status = "BAD";
      else if (code.contains("repos")) status = "REPOSITION";
      else if (code.contains("repa")) status = "REPARATION";

      grouped.putIfAbsent(ans.sectionName, () => []).add({
        "name": ans.componentName,
        "status": status,
        "observation": ans.observation,
        "foto_antes_bytes": ans.evidenceBytes,
        "foto_despues_bytes": null,
      });
    }

    return {
      "unidad": "${data.vehicle.brand} ${data.vehicle.model}",
      "fecha": data.report['inspection_date']?.toString().split('T')[0] ?? "",
      "placas": data.vehicle.plate,
      "kilometraje": data.report['mileage'] ?? 0,
      "requiere_servicio": data.report['requires_service'] ?? false,
      "notas": data.report['general_notes'] ?? "",
      "secciones": grouped.entries
          .map((e) => {"name": e.key, "items": e.value})
          .toList(),
    };
  }
}