import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:crv_reprosisa/core/utils/imege_downloader.dart';
import 'package:crv_reprosisa/core/utils/pdf_report_manager.dart';
import 'package:crv_reprosisa/core/utils/SGC-PO-MT-01-FO-03-VEHICLE.dart';
import 'package:crv_reprosisa/core/utils/SGC-PO-MT-01-FO-08-PRESS.dart';
import 'banda_pdf_generator.dart';

class PdfReportCoordinator {
  static Future<Uint8List?> generate(Dio dio, dynamic model, String tipo) async {
    final type = tipo.toUpperCase();

    if (type.contains('PRESS')) {
      return await _generatePressPdf(dio, model);
    } else if (type.contains('VEHICLE')) {
      return await PdfReportManager.generatePdf(
        dio: dio,
        detailModel: model,
        mapper: (m) => VehiculoPdfGenerator.mapDetailModelToPdfData(m),
        generator: (data) => VehiculoPdfGenerator.generateEsqueleto(data),
      );
    } else if (type.contains('CONVEYOR')) {
      // Reutiliza tu lógica de banda existente
      return null; // Implementa tu BandaPdfGenerator aquí
    }
    return null;
  }

  static Future<Uint8List?> _generatePressPdf(Dio dio, dynamic model) async {
    final Map<int, Map<String, Uint8List>> cacheImagenes = {};
    for (int i = 0; i < model.answers.length; i++) {
      var answer = model.answers[i];
      if (answer.evidencePaths != null && answer.evidencePaths is List) {
        final paths = answer.evidencePaths as List;
        final Map<String, Uint8List> fotos = {};
        for (int j = 0; j < paths.length; j++) {
          final bytes = await ImageDownloader.download(dio, paths[j]);
          if (bytes != null) {
            if (j == 0) fotos['antes'] = bytes;
            if (j == 1) fotos['despues'] = bytes;
          }
        }
        cacheImagenes[i] = fotos;
      }
    }

    return await PdfReportManager.generatePdf(
      dio: dio,
      detailModel: model,
      mapper: (m) {
        final data = PrensaPdfGenerator.mapDetailModelToPdfData(m);
        for (int i = 0; i < data['items'].length; i++) {
          if (cacheImagenes.containsKey(i)) {
            data['items'][i]['foto_antes_bytes'] = cacheImagenes[i]!['antes'];
            data['items'][i]['foto_despues_bytes'] = cacheImagenes[i]!['despues'];
          }
        }
        return data;
      },
      generator: (data) => PrensaPdfGenerator.generateEsqueleto(data),
    );
  }
}