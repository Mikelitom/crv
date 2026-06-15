import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'imege_downloader.dart';
class PdfReportManager {
  static Future<Uint8List?> generatePdf({
    required Dio dio,
    required dynamic detailModel,
    required Map<String, dynamic> Function(dynamic) mapper,
    required Future<Uint8List> Function(Map<String, dynamic>) generator,
  }) async {
    try {
      // 1. Mapear el modelo
      final pdfData = mapper(detailModel);

      // 2. Descargar imágenes de forma masiva usando el Dio autenticado
      if (pdfData.containsKey('secciones')) {
        for (var sec in pdfData['secciones']) {
          for (var subItem in sec['items']) {
            if (subItem['url_antes'] != null) {
              subItem['foto_antes_bytes'] = await ImageDownloader.download(dio, subItem['url_antes']);
            }
            if (subItem['url_despues'] != null) {
              subItem['foto_despues_bytes'] = await ImageDownloader.download(dio, subItem['url_despues']);
            }
          }
        }
      }

      // 3. Generar PDF
      return await generator(pdfData);
    } catch (e) {
      print("Error en PdfReportManager: $e");
      return null;
    }
  }
}