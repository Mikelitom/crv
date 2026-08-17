import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/press_report_detail_provider.dart';
import 'package:dio/dio.dart' as dio_package;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class PressPdfProcessor {
  static final List<String> ordenOficial = [
    "NIVELES DE ACEITE",
    "MANOMETRO EN CERO",
    "PRENSA EN MODO MANUAL",
    "PRENSA EN MODO AUTOMÁTICO",
    "PRENSA TEMPERATURA AMBIENTE AL INICIAR",
    "DE 10-30 MINUTOS TEMPERATURA A 140-160 C°",
    "MANGUERAS DE ACEITE",
    "CABLEADO",
    "RUIDOS INUSUALES",
    "CAJA DE CONTROL Y/O CABEZAS DE CONTROL",
    "PLATO SUPERIOR",
    "PLATO INFERIOR",
    "CÁMARA DE PRESIÓN Y/O ACOPLE RÁPIDO",
    "CALIBRADO DE PRESIÓN Y/O MANGUERA DE LLENADO",
    "TORNILLOS Y/O PERNOS",
    "PLATOS DE COMPENSADORES DE CALOR",
    "RIELES",
    "MANGUERAS PARA ENFRIAMIENTO",
    "SEGUROS DE RIELES",
    "SISTEMA DE PRESIÓN: BOMBA /COMPRESOR",
    "LIMPIEZA",
    "ESTRUCTURA/ SOLDADURA",
    "CABLES TERMOPARES Y LECTOR",
  ];
  
  static Future<Map<String, dynamic>?> generatePdfFromVersionId(
    WidgetRef ref,
    String versionId,
  ) async {
    try {
      final data = await _getReportData(ref, versionId);
      if (data == null) return null;
      return data;
    } catch (e) {
      debugPrint("Error generando PDF: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> _getReportData(
    WidgetRef ref,
    String versionId,
  ) async {
    final notifier = ref.read(pressReportDetailProvider.notifier);
    await notifier.fetchDetail(versionId);
    final state = ref.read(pressReportDetailProvider);

    if (state.data == null) {
      return null;
    }

    final data = state.data!;

    // Extracción segura de datos del reporte (Maneja tanto Map como propiedades directas)
    final reportMap = data.report;
    final pressMap = data.press;

    // 1. Fecha de inspección segura
    String fechaStr = DateTime.now().toIso8601String();
    final rawDate = reportMap['inspection_date'] ?? reportMap['fecha'];
    if (rawDate != null) {
      try {
        fechaStr = DateFormat('yyyy-MM-dd').format(DateTime.parse(rawDate.toString()));
      } catch (_) {
        fechaStr = rawDate.toString();
      }
    }

    // 2. Extracción de Área (Evita que tome "General" por defecto si existe un valor real)
    final String areaReporte = (reportMap['area'] ?? reportMap['ubicacion'] ?? 'N/A').toString();

    List<Map<String, dynamic>> itemsOrdenados = [];
    List<dynamic> respuestasPendientes = List.from(data.answers);

    for (var nombre in ordenOficial) {
      final index = respuestasPendientes.indexWhere(
        (a) => a.componentName.toUpperCase().trim() == nombre.toUpperCase().trim(),
      );

      if (index != -1) {
        itemsOrdenados.add(
          await _mapAnswerToMap(ref, respuestasPendientes.removeAt(index)),
        );
      }
    }

    for (final answer in respuestasPendientes) {
      itemsOrdenados.add(await _mapAnswerToMap(ref, answer));
    }

    return {
      'fecha': fechaStr,
      'tipo': pressMap['type'] ?? pressMap['tipo'] ?? 'N/A',
      'modelo': pressMap['model'] ?? pressMap['modelo'] ?? 'N/A',
      'volts': pressMap['voltz'] ?? pressMap['volts'] ?? 'N/A',
      'serie': pressMap['serie'] ?? pressMap['serial'] ?? 'N/A',
      'folio': reportMap['folio'] ?? 'N/A',
      'area': areaReporte, // <-- Área corregida y extraída correctamente
      'area_solicita': reportMap['loan_area'] ?? reportMap['loan']?['area_id'] ?? '',
      'nombre_recibe': reportMap['loan_received_by'] ?? reportMap['loan']?['solicitants_name'] ?? '',
      'observaciones_footer': reportMap['general_notes'] ?? reportMap['observation'] ?? '',
      'items': itemsOrdenados,
    };
  }

  static Future<Uint8List?> _downloadImageBytes(
    WidgetRef ref,
    String url,
  ) async {
    try {
      final dio = ref.read(dioProvider);
      final response = await dio.get(
        url,
        options: dio_package.Options(
          responseType: dio_package.ResponseType.bytes,
        ),
      );

      return response.statusCode == 200
          ? Uint8List.fromList(response.data)
          : null;
    } catch (e) {
      debugPrint("Error descargando imagen: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>> _mapAnswerToMap(
    WidgetRef ref,
    dynamic answer,
  ) async {
    Uint8List? bytesAntes;
    Uint8List? bytesDespues;

    if (answer.evidencePaths.isNotEmpty) {
      bytesAntes = await _downloadImageBytes(ref, answer.evidencePaths[0]);
    }

    if (answer.evidencePaths.length >= 2) {
      bytesDespues = await _downloadImageBytes(ref, answer.evidencePaths[1]);
    }

    return {
      'name': answer.componentName,
      'status': answer.status,
      'observation': (answer.observation == "Notaas" || answer.observation.isEmpty)
          ? ''
          : answer.observation,
      'measureUnit': answer.measureUnit,
      'quantity': answer.quantity,
      'foto_antes_bytes': bytesAntes,
      'foto_despues_bytes': bytesDespues,
    };
  }
}