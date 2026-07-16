import 'dart:typed_data';

import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/core/utils/banda_pdf_generator.dart';
import 'package:crv_reprosisa/core/utils/imege_downloader.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/conveyor_report_detail.dart'
    hide Roller;
import 'package:crv_reprosisa/features/assets/presentation/providers/conveyor_report_detail_provider.dart';
import 'package:crv_reprosisa/features/bandas_transportadoras/domain/entities/banda_template.dart';
import 'package:crv_reprosisa/features/bandas_transportadoras/domain/entities/roller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConveyorPdfData {
  final Map<String, dynamic> datosNormalizados;
  final List<BandaSection> sections;
  final List<Roller> rodillos;

  const ConveyorPdfData({
    required this.datosNormalizados,
    required this.sections,
    required this.rodillos,
  });
}

class ConveyorPdfProcessor {
  static Future<Uint8List?> generatePdfFromVersionId(
    WidgetRef ref,
    String versionId,
  ) async {
    try {
      final pdfData = await getPdfData(ref, versionId);

      if (pdfData == null) return null;

      return BandaPdfGenerator.generateReport(
        pdfData.datosNormalizados,
        pdfData.sections,
        pdfData.rodillos,
      );
    } catch (e) {
      debugPrint("Error generando PDF: $e");
      return null;
    }
  }

  static Future<ConveyorPdfData?> getPdfData(
    WidgetRef ref,
    String versionId,
  ) async {
    try {
      final reportDetail = await ref
          .read(conveyorReportDetailProvider.notifier)
          .fetchDetail(versionId);

      if (reportDetail == null) return null;

      final dio = ref.read(dioProvider);

      for (final answer in reportDetail.answers) {
        for (final evidence in answer.evidences) {
          evidence.bytes ??= await ImageDownloader.download(
            dio,
            evidence.signedUrl,
          );
        }
      }

      final String seccionGeneral =
          reportDetail.report['section']?.toString() ?? "";

      final Map<String, dynamic> datosNormalizados = {
        'planta': reportDetail.conveyor['mine'] ?? "",
        'area': reportDetail.conveyor['area'] ?? "",
        'responsable':
            reportDetail.report['conveyor_responsible'] ?? "",
        'seccion': seccionGeneral,
        'transportador': reportDetail.conveyor['name'] ?? "",
        'banda': reportDetail.report['recommended_belt'] ?? "",
        'material':
            "${reportDetail.report['material'] ?? ''} / ${reportDetail.report['granulometry'] ?? ''}",
        'elaboro': reportDetail.inspector['name'] ?? "",
        'presentar': reportDetail.report['present_to'] ?? "",
        'comentarios': reportDetail.report['comentarios'] ?? "",
      };

      final sections = await _mapAnswersToSections(
        reportDetail.answers,
      );

      final List<Roller> rodillos = reportDetail.rollers
          .map(
            (r) => Roller(
              tableNumber: r.tableNumber,
              baseNumber: r.baseNumber,
              isLeft: r.isLeft,
              isCenter: r.isCenter,
              isRight: r.isRight,
              isImpact: r.isImpact,
              isReturn: r.isReturn,
              isTriple: r.isTriple,
              isSelfAligning: r.isSelfAligning,
              observation: r.observation,
            ),
          )
          .toList();

      return ConveyorPdfData(
        datosNormalizados: datosNormalizados,
        sections: sections,
        rodillos: rodillos,
      );
    } catch (e) {
      debugPrint("Error preparando datos del PDF: $e");
      return null;
    }
  }

  static Future<List<BandaSection>> _mapAnswersToSections(
    List<Answer> answers,
  ) async {
    final Map<String, List<BandaComponent>> sectionsMap = {};

    for (final a in answers) {
      if (!sectionsMap.containsKey(a.section.name)) {
        sectionsMap[a.section.name] = [];
      }

      final List<BandaOption> opcionesFijas =
          BandaPdfGenerator.obtenerOpcionesFijasParaComponente(
        a.accessory.name,
      );

      final List<EvidenceFile> evidenciasConvertidas = a.evidences
          .where((e) => e.bytes != null)
          .map(
            (e) => EvidenceFile(
              bytes: e.bytes!,
              type: e.fileType,
              mimeType: e.mimeType,
            ),
          )
          .toList();

      sectionsMap[a.section.name]!.add(
        BandaComponent(
          id: a.answerId,
          name: a.accessory.name,
          observation: a.recommendedAction.trim(),
          options: opcionesFijas,
          comment: a.comment ?? '',
          selectedOptionIds: [
            if (a.option != null) ...[
              a.option!.id.toString().trim().toLowerCase(),
              a.option!.label.toString().trim().toLowerCase(),
              a.option!.value.toString().trim().toLowerCase(),
            ],
          ],
          customOptions:
              (a.customOption != null && a.customOption!.isNotEmpty)
                  ? [a.customOption!]
                  : [],
          dimentions: a.dimentions,
          evidenceBefore: evidenciasConvertidas,
          evidenceAfter: [],
        ),
      );
    }

    return sectionsMap.entries
        .map(
          (e) => BandaSection(
            id: e.key.hashCode.toString(),
            name: e.key,
            components: e.value,
          ),
        )
        .toList();
  }
}