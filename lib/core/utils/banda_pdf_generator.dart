import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../features/bandas_transportadoras/domain/entities/roller.dart';
import '../../features/bandas_transportadoras/domain/entities/banda_template.dart';

class BandaPdfGenerator {
  static final _kBorderColor = PdfColors.black;
  static final _kGreyHeader = PdfColor.fromHex("#D3D3D3");

  static List<BandaOption> obtenerOpcionesFijasParaComponente(
    String componentName,
  ) {
    final name = componentName.trim().toLowerCase();
    switch (name) {
      case 'banda en la polea':
        return [
          BandaOption(id: 'alineada', label: 'alineada', value: 'alineada'),
          BandaOption(
            id: 'desalineada',
            label: 'desalineada',
            value: 'desalineada',
          ),
        ];
      case 'raspador de retorno':
        return [
          BandaOption(id: 'hay', label: 'hay', value: 'hay'),
          BandaOption(id: 'no_hay', label: 'no hay', value: 'no_hay'),
          BandaOption(id: 'raspa', label: 'raspa', value: 'raspa'),
          BandaOption(id: 'no_raspa', label: 'no raspa', value: 'no_raspa'),
        ];
      case 'hule raspador':
        return [
          BandaOption(id: 'bueno', label: 'bueno', value: 'bueno'),
          BandaOption(id: 'cambiar', label: 'cambiar', value: 'cambiar'),
          BandaOption(id: 'ajustar', label: 'ajustar', value: 'ajustar'),
        ];
      case 'polea de cola':
        return [
          BandaOption(id: 'ahogada', label: 'ahogada', value: 'ahogada'),
          BandaOption(id: 'lisa', label: 'lisa', value: 'lisa'),
          BandaOption(
            id: 'recubierta',
            label: 'recubierta',
            value: 'recubierta',
          ),
          BandaOption(
            id: 'cristalizada',
            label: 'cristalizada',
            value: 'cristalizada',
          ),
          BandaOption(
            id: 'jaula_de_ardilla',
            label: 'jaula de ardilla',
            value: 'jaula de ardilla',
          ),
        ];
      case 'material atrapado':
        return [
          BandaOption(id: 'hay', label: 'hay', value: 'hay'),
          BandaOption(id: 'no_hay', label: 'no hay', value: 'no_hay'),
        ];
      case 'zona de impacto':
        return [
          BandaOption(id: 'rodillos', label: 'rodillos', value: 'rodillos'),
          BandaOption(id: 'barras', label: 'barras', value: 'barras'),
        ];
      case 'rodillos de impacto':
        return [
          BandaOption(id: 'hay', label: 'hay', value: 'hay'),
          BandaOption(id: 'frenados', label: 'frenados', value: 'frenados'),
          BandaOption(id: 'dañados', label: 'dañados', value: 'dañados'),
          BandaOption(id: 'ahogados', label: 'ahogados', value: 'ahogados'),
          BandaOption(id: 'cambiar', label: 'cambiar', value: 'cambiar'),
        ];
      case 'barras de impacto':
        return [
          BandaOption(id: 'hay', label: 'hay', value: 'hay'),
          BandaOption(id: 'dañadas', label: 'dañadas', value: 'dañadas'),
          BandaOption(
            id: 'desgastados',
            label: 'desgastados',
            value: 'desgastados',
          ),
          BandaOption(id: 'no_tiene', label: 'no tiene', value: 'no_tiene'),
        ];
      case 'carga en la banda':
        return [
          BandaOption(id: 'al_centro', label: 'al centro', value: 'al centro'),
          BandaOption(
            id: 'descentrada',
            label: 'descentrada',
            value: 'descentrada',
          ),
          BandaOption(id: 'derrames', label: 'derrames', value: 'derrames'),
        ];
      case 'faldón metálico':
        return [
          BandaOption(id: 'al_%', label: 'al %', value: 'al %'),
          BandaOption(
            id: 'más_abierto',
            label: 'más abierto',
            value: 'más abierto',
          ),
          BandaOption(id: 'corto', label: 'corto', value: 'corto'),
        ];
      case 'hule faldón':
        return [
          BandaOption(id: 'flexible', label: 'flexible', value: 'flexible'),
          BandaOption(id: 'rígido', label: 'rígido', value: 'rígido'),
          BandaOption(id: 'de_banda', label: 'de banda', value: 'de banda'),
        ];
      case 'cubierta de carga':
        return [
          BandaOption(
            id: 'buen_estado',
            label: 'buen estado',
            value: 'buen estado',
          ),
          BandaOption(
            id: 'desgastada',
            label: 'desgastada',
            value: 'desgastada',
          ),
          BandaOption(id: 'rayada', label: 'rayada', value: 'rayada'),
          BandaOption(
            id: 'cristalizada',
            label: 'cristalizada',
            value: 'cristalizada',
          ),
          BandaOption(id: 'picada', label: 'picada', value: 'picada'),
        ];
      case 'estado de la banda':
        return [
          BandaOption(id: 'bueno', label: 'bueno', value: 'bueno'),
          BandaOption(id: 'regular', label: 'regular', value: 'regular'),
          BandaOption(id: 'malo', label: 'malo', value: 'malo'),
        ];
      case 'daños por parar':
        return [
          BandaOption(id: 'mayores', label: 'mayores', value: 'mayores'),
          BandaOption(id: 'menores', label: 'menores', value: 'menores'),
          BandaOption(id: 'empalmar', label: 'empalmar', value: 'empalmar'),
        ];
      case 'empalmes':
        return [
          BandaOption(
            id: 'existentes',
            label: 'existentes',
            value: 'existentes',
          ),
          BandaOption(
            id: 'por_reparar',
            label: 'por reparar',
            value: 'por reparar',
          ),
          BandaOption(id: 'cambiar', label: 'cambiar', value: 'cambiar'),
        ];
      case 'soportes de carga':
        return [
          BandaOption(id: '20º', label: '20º', value: '20º'),
          BandaOption(id: '35º', label: '35º', value: '35º'),
          BandaOption(id: '45º', label: '45º', value: '45º'),
          BandaOption(id: 'planos', label: 'planos', value: 'planos'),
          BandaOption(id: 'cambiar', label: 'cambiar', value: 'cambiar'),
        ];
      case 'soportes autoalineables':
        return [
          BandaOption(id: 'hay', label: 'hay', value: 'hay'),
          BandaOption(id: 'no_hay', label: 'no hay', value: 'no_hay'),
          BandaOption(
            id: 'sin_maracas',
            label: 'sin maracas',
            value: 'sin maracas',
          ),
          BandaOption(
            id: 'bloqueados',
            label: 'bloqueados',
            value: 'bloqueados',
          ),
          BandaOption(id: 'cambiar', label: 'cambiar', value: 'cambiar'),
        ];
      case 'polea de cabeza':
        return [
          BandaOption(id: 'lisa', label: 'lisa', value: 'lisa'),
          BandaOption(
            id: 'recubierta',
            label: 'recubierta',
            value: 'recubierta',
          ),
        ];
      case 'revestimiento':
        return [
          BandaOption(id: 'bueno', label: 'bueno', value: 'bueno'),
          BandaOption(id: 'dañado', label: 'dañado', value: 'dañado'),
          BandaOption(id: 'cambiar', label: 'cambiar', value: 'cambiar'),
        ];
      case 'raspadores':
        return [
          BandaOption(id: 'no_hay', label: 'no hay', value: 'no_hay'),
          BandaOption(id: 'primario', label: 'primario', value: 'primario'),
          BandaOption(id: 'ajustar', label: 'ajustar', value: 'ajustar'),
          BandaOption(
            id: 'secundarios',
            label: 'secundarios',
            value: 'secundarios',
          ),
          BandaOption(id: 'ajustar', label: 'ajustar', value: 'ajustar'),
        ];
      case 'limpieza':
        return [
          BandaOption(id: 'buena', label: 'buena', value: 'buena'),
          BandaOption(id: 'regular', label: 'regular', value: 'regular'),
          BandaOption(id: 'mala', label: 'mala', value: 'mala'),
        ];
      case 'tolva de traspaso':
        return [
          BandaOption(id: 'limpia', label: 'limpia', value: 'limpia'),
          BandaOption(id: 'con_fugas', label: 'con fugas', value: 'con fugas'),
          BandaOption(
            id: 'adherencias',
            label: 'adherencias',
            value: 'adherencias',
          ),
        ];
      case 'modificar':
        return [
          BandaOption(id: 'frontis', label: 'frontis', value: 'frontis'),
          BandaOption(id: 'laterales', label: 'laterales', value: 'laterales'),
          BandaOption(
            id: 'tolva_de_finos',
            label: 'tolva de finos',
            value: 'tolva de finos',
          ),
          BandaOption(id: 'rediseñar', label: 'rediseñar', value: 'rediseñar'),
        ];
      case 'tolva de finos':
        return [
          BandaOption(id: 'limpia', label: 'limpia', value: 'limpia'),
          BandaOption(
            id: 'entortadas',
            label: 'entortadas',
            value: 'entortadas',
          ),
          BandaOption(id: 'mover', label: 'mover', value: 'mover'),
        ];
      case 'banda de retorno':
        return [
          BandaOption(id: 'limpia', label: 'limpia', value: 'limpia'),
          BandaOption(id: 'sucia', label: 'sucia', value: 'sucia'),
        ];
      case 'polea de contacto':
        return [
          BandaOption(id: 'hay', label: 'hay', value: 'hay'),
          BandaOption(id: 'no_hay', label: 'no hay', value: 'no_hay'),
          BandaOption(id: 'lisa', label: 'lisa', value: 'lisa'),
          BandaOption(
            id: 'recubierta',
            label: 'recubierta',
            value: 'recubierta',
          ),
        ];
      case 'limpieza bajo el transportador':
        return [
          BandaOption(id: 'buena', label: 'buena', value: 'buena'),
          BandaOption(id: 'regular', label: 'regular', value: 'regular'),
          BandaOption(id: 'mala', label: 'mala', value: 'mala'),
        ];
      case 'rodillos de retorno':
        return [
          BandaOption(id: 'limpios', label: 'limpios', value: 'limpios'),
          BandaOption(
            id: 'entortados',
            label: 'entortados',
            value: 'entortados',
          ),
          BandaOption(id: 'ahogados', label: 'ahogados', value: 'ahogados'),
          BandaOption(id: 'cambiar', label: 'cambiar', value: 'cambiar'),
        ];
      case 'rodillos autoalineables':
        return [
          BandaOption(id: 'hay', label: 'hay', value: 'hay'),
          BandaOption(id: 'no_hay', label: 'no hay', value: 'no_hay'),
          BandaOption(
            id: 'sin_maracas',
            label: 'sin maracas',
            value: 'sin maracas',
          ),
          BandaOption(
            id: 'bloqueados',
            label: 'bloqueados',
            value: 'bloqueados',
          ),
          BandaOption(id: 'cambiar', label: 'cambiar', value: 'cambiar'),
        ];
      case 'alineación':
        return [
          BandaOption(id: 'buena', label: 'buena', value: 'buena'),
          BandaOption(id: 'regular', label: 'regular', value: 'regular'),
          BandaOption(id: 'mala', label: 'mala', value: 'mala'),
        ];
      case 'banda en las poleas dobladoras':
        return [
          BandaOption(id: 'alineada', label: 'alineada', value: 'alineada'),
          BandaOption(
            id: 'desalineadas',
            label: 'desalineadas',
            value: 'desalineadas',
          ),
        ];
      case 'banda en la polea de contrapeso':
        return [
          BandaOption(id: 'alineada', label: 'alineada', value: 'alineada'),
          BandaOption(
            id: 'desalineadas',
            label: 'desalineadas',
            value: 'desalineadas',
          ),
        ];
      case 'poleas de dobles':
        return [
          BandaOption(id: 'lisas', label: 'lisas', value: 'lisas'),
          BandaOption(
            id: 'recubiertas',
            label: 'recubiertas',
            value: 'recubiertas',
          ),
          BandaOption(id: 'limpias', label: 'limpias', value: 'limpias'),
          BandaOption(
            id: 'cristalizada',
            label: 'cristalizada',
            value: 'cristalizada',
          ),
          BandaOption(id: 'cambiar', label: 'cambiar', value: 'cambiar'),
        ];
      case 'polea de contrapeso':
        return [
          BandaOption(id: 'lisa', label: 'lisa', value: 'lisa'),
          BandaOption(
            id: 'recubiertas',
            label: 'recubiertas',
            value: 'recubiertas',
          ),
          BandaOption(id: 'ahogada', label: 'ahogada', value: 'ahogada'),
        ];
      case 'desviador de material':
        return [
          BandaOption(id: 'hay', label: 'hay', value: 'hay'),
          BandaOption(id: 'no_hay', label: 'no hay', value: 'no_hay'),
        ];
      default:
        return [];
    }
  }

  static Map<String, dynamic> mapDetailModelToPdfData(dynamic model) {
    final Map<String, List<BandaComponent>> grouped = {};
    final Map<String, String> sectionIdMap = {};

    for (var ans in model.answers) {
      final sectionId = ans.section.id?.toString() ?? 'sin_id';
      final sectionName = ans.section.name?.toString() ?? 'Sin Sección';

      if (!grouped.containsKey(sectionName)) {
        grouped[sectionName] = [];
        sectionIdMap[sectionName] = sectionId;
      }

      final componentName = ans.accessory.name ?? '';
      final List<BandaOption> opcionesFijas =
          obtenerOpcionesFijasParaComponente(componentName);
      grouped[sectionName]!.add(
        BandaComponent(
          id: ans.answerId,
          name: componentName,
          options: opcionesFijas,
          selectedOptionIds: [
            ans.option.id.toString(),
            ans.option.label.toString(),
            ans.option.value.toString(),
          ],
          observation: ans.recommendedAction ?? '',
          evidenceBefore: [],
          evidenceAfter: [],
        ),
      );
    }

    // 2. Convertimos a la lista que espera tu generateReport
    final List<BandaSection> sections = grouped.entries.map((e) {
      return BandaSection(
        id: sectionIdMap[e.key] ?? 'sec_${e.key}',
        name: e.key,
        components: e.value,
      );
    }).toList();

    return {
      'planta': model.report['plant_name'] ?? 'N/A',
      'area': model.conveyor['area'] ?? 'N/A',
      'responsable': model.report['conveyor_responsible'] ?? 'N/A',
      'seccion': 'N/A',
      'fecha': model.report['inspection_date'] ?? 'N/A',
      'transportador': model.conveyor['name'] ?? 'N/A',
      'banda': model.report['recommended_belt'] ?? 'N/A',
      'material':
          "${model.report['material'] ?? ''} / ${model.report['granulometry'] ?? ''}",
      'elaboro': model.inspector['name'] ?? 'N/A',
      'presentar': model.report['present_to'] ?? 'N/A',
      'comentarios': model.report['general_comments'] ?? '',
      'sections': sections,
    };
  }

  static Future<Uint8List> generateEsqueleto(Map<String, dynamic> data) async {
    final List<Roller> rodillos = data['rodillos'] ?? [];
    final List<BandaSection> sections = data['sections'] as List<BandaSection>;

    return await generateReport(data, sections, rodillos);
  }
static Future<Uint8List> generateReport(
    Map<String, dynamic> data,
    List<BandaSection> sections,
    List<Roller> rodillos,
  ) async {
    final pdf = pw.Document();
    pw.ImageProvider? fullHeaderImg;
    try {
      final headerBytes = await rootBundle.load('assets/images/bandas_pdf.png');
      fullHeaderImg = pw.MemoryImage(headerBytes.buffer.asUint8List());
    } catch (e) {
      print("Error: No se encontro la imagen en assets/images/bandas_pdf.png");
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter,
        margin: const pw.EdgeInsets.all(15),
        header: (context) => _buildFullHeader(fullHeaderImg),
        build: (context) => [
          // 1. Información General
          _buildInfoGrid(data),
          pw.SizedBox(height: 5),
          
          // 2. Tabla Resumen (la que ya tenías)
          _buildMainTable(sections),
          
          pw.SizedBox(height: 10),
          
          // 3. NUEVO: Desglose por Secciones detallado
          pw.Text("DESGLOSE DETALLADO POR SECCIONES", 
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8)),
          pw.SizedBox(height: 5),
          _buildDesglosePorSecciones(sections),
          
          pw.SizedBox(height: 10),
          
          // 4. Pie técnico (Rodillos y Comentarios)
          _buildTechnicalFooter(data, rodillos),
        ],
      ),
    );
    return pdf.save();
  }
  static pw.Widget _buildDesglosePorSecciones(List<BandaSection> sections) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: sections.map((section) {
        return pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 10),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Título de la Sección (Encabezado)
              pw.Container(
                color: _kGreyHeader,
                width: double.infinity,
                padding: const pw.EdgeInsets.all(5),
                child: pw.Text("SECCIÓN: ${section.name.toUpperCase()}", 
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
              ),
              
              // Tabla detallada
              pw.Table(
                border: pw.TableBorder.all(width: 0.5),
                columnWidths: {
                  0: const pw.FlexColumnWidth(1.5), // Accesorio
                  1: const pw.FlexColumnWidth(2.0), // Opciones
                  2: const pw.FlexColumnWidth(1.0), // Dimensión
                  3: const pw.FlexColumnWidth(2.0), // Observaciones
                  4: const pw.FlexColumnWidth(2.0), // Evidencias
                },
                children: [
                  // Header de la tabla de desglose
                  pw.TableRow(decoration: pw.BoxDecoration(color: PdfColors.grey200), children: [
                    _cell("ACCESORIO", bold: true),
                    _cell("OPCIONES", bold: true),
                    _cell("DIM.", bold: true),
                    _cell("OBSERVACIÓN", bold: true),
                    _cell("EVIDENCIAS", bold: true),
                  ]),
                  
                  // Filas de datos
                  ...section.components.map((c) => pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(c.name, style: const pw.TextStyle(fontSize: 7))),
                    pw.Padding(padding: const pw.EdgeInsets.all(2), child: _buildOptionsInRow(c.options, c.selectedOptionIds, c.customOptions)),
                    _cell(c.dimentions),
                    pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(c.observation, style: const pw.TextStyle(fontSize: 7))),
                    _buildEvidenciaConAccesorio(c), // Nueva función abajo
                  ])),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // Nueva función para mostrar la imagen pequeña junto al nombre
  static pw.Widget _buildEvidenciaConAccesorio(BandaComponent c) {
    final allEvidences = [...c.evidenceBefore, ...c.evidenceAfter];
    if (allEvidences.isEmpty) return pw.SizedBox();

    return pw.Wrap(
      spacing: 5,
      runSpacing: 5,
      children: allEvidences.map((e) => pw.Container(
        width: 30,
        height: 30,
        child: pw.Image(pw.MemoryImage(e.bytes), fit: pw.BoxFit.cover),
      )).toList(),
    );
  }

  static pw.Widget _buildFullHeader(pw.ImageProvider? img) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _kBorderColor, width: 1),
      ),
      child: pw.Column(
        children: [
          if (img != null)
            pw.Container(
              width: double.infinity,
              height: 50,
              child: pw.Image(img, fit: pw.BoxFit.contain),
            ),
          pw.Container(
            width: double.infinity,
            decoration: pw.BoxDecoration(
              color: _kGreyHeader,
              border: pw.Border(
                top: pw.BorderSide(color: _kBorderColor, width: 1),
              ),
            ),
            padding: const pw.EdgeInsets.symmetric(vertical: 3),
            child: pw.Text(
              "REPORTE DE INSPECCION DE BANDA TRANSPORTADORA",
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildInfoGrid(Map<String, dynamic> data) {
    return pw.Table(
      border: pw.TableBorder.all(width: 1.0, color: _kBorderColor),
      columnWidths: {
        0: const pw.FlexColumnWidth(1),
        1: const pw.FlexColumnWidth(2),
        2: const pw.FlexColumnWidth(1),
        3: const pw.FlexColumnWidth(2),
      },
      children: [
        _infoRow("PLANTA:", data['planta'], "ÁREA:", data['area']),
        _infoRow(
          "RESPONSABLE:",
          data['responsable'],
          "SECCIÓN:",
          data['seccion'],
        ),
        _infoRow(
          "FECHA:",
          data['fecha'],
          "TRANSPORTADOR:",
          data['transportador'],
        ),
        _infoRow(
          "BANDA RECOMENDADA:",
          data['banda'],
          "MATERIAL Y GRANULOMETRÍA:",
          data['material'],
        ),
        _infoRow(
          "ELABORÓ:",
          data['elaboro'],
          "PRESENTAR A:",
          data['presentar'],
        ),
      ],
    );
  }

  static pw.TableRow _infoRow(String l1, dynamic v1, String l2, dynamic v2) {
    return pw.TableRow(
      children: [
        pw.Container(
          color: _kGreyHeader,
          alignment: pw.Alignment.centerRight,
          padding: const pw.EdgeInsets.all(3),
          constraints: const pw.BoxConstraints(minHeight: 18),
          child: pw.Text(
            l1,
            textAlign: pw.TextAlign.right,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 6.5),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(3),
          child: pw.Text(
            v1?.toString() ?? "",
            style: const pw.TextStyle(fontSize: 7),
          ),
        ),
        pw.Container(
          color: _kGreyHeader,
          alignment: pw.Alignment.centerRight,
          padding: const pw.EdgeInsets.all(3),
          constraints: const pw.BoxConstraints(minHeight: 18),
          child: pw.Text(
            l2,
            textAlign: pw.TextAlign.right,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 6.5),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(3),
          child: pw.Text(
            v2?.toString() ?? "",
            style: const pw.TextStyle(fontSize: 7),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildMainTable(List<BandaSection> sections) {
    return pw.Table(
      border: pw.TableBorder.all(width: 0.5, color: _kBorderColor),
      columnWidths: {
        0: const pw.FlexColumnWidth(0.6),
        1: const pw.FlexColumnWidth(1.2),
        2: const pw.FlexColumnWidth(
          2.5,
        ), // Esta columna ahora ocupa el mayor espacio
        3: const pw.FlexColumnWidth(1.0),
        4: const pw.FlexColumnWidth(0.6),
      },
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: _kGreyHeader),
          children: [
            _cell("SECCION", bold: true),
            _cell("ACCESORIOS", bold: true),
            _cell("OBSERVACIONES", bold: true),
            _cell("RECOMENDACION", bold: true),
            _cell("EVID.", bold: true),
          ],
        ),
        ...sections.map((s) {
          return pw.TableRow(
            children: [
              _cell(s.name, bold: true),
              // Usamos una sub-tabla para asegurar que cada fila tenga la misma altura
              _buildNestedTable(s.components, isNameColumn: true),
              _buildNestedTable(s.components, isOptionsColumn: true),
              _buildNestedTable(s.components, isObsColumn: true),
              _buildNestedTable(s.components, isEvidenceColumn: true),
            ],
          );
        }).toList(),
      ],
    );
  }
static pw.Widget _buildNestedTable(
    List<BandaComponent> components, {
    bool isNameColumn = false,
    bool isOptionsColumn = false,
    bool isObsColumn = false,
    bool isEvidenceColumn = false,
  }) {
    return pw.Table(
      border: pw.TableBorder(horizontalInside: const pw.BorderSide(width: 0.5)),
      children: components.map((c) {
        return pw.TableRow(
          children: [
            pw.Container(
              padding: const pw.EdgeInsets.all(5),
              constraints: const pw.BoxConstraints(minHeight: 25),
              alignment: pw.Alignment.centerLeft,
              child: isNameColumn
                  ? pw.Text(c.name, style: const pw.TextStyle(fontSize: 5.5))
                  : isOptionsColumn
? _buildOptionsInRow(c.options, c.selectedOptionIds, c.customOptions) // CORREGIDO                          ? pw.Text(c.observation, style: const pw.TextStyle(fontSize: 6.5))
                          : _buildMiniEvidences(c),
            ),
          ],
        );
      }).toList(),
    );
  }
static pw.Widget _buildOptionsInRow(
  List<BandaOption> opcionesFijas,
  List<String> selectedIds,
  List<String> customOptions,
) {
  // 1. Normalización de IDs/Labels/Values recibidos para comparación robusta
  final cleanSelected = selectedIds
      .where((e) => e.isNotEmpty)
      .map((e) => e.trim().toLowerCase())
      .toList();

  return pw.Wrap(
    spacing: 10,
    runSpacing: 2,
    children: [
      // 2. Renderizar opciones fijas del catálogo
      ...opcionesFijas.map((opt) {
        // Comparación con ID, Label y Value normalizados
        final isSelected = cleanSelected.contains(opt.id.trim().toLowerCase()) ||
                           cleanSelected.contains(opt.label.trim().toLowerCase()) ||
                           cleanSelected.contains(opt.value.trim().toLowerCase());

        return pw.Container(
          child: pw.Text(
            isSelected ? "[X] ${opt.label}" : "[ ] ${opt.label}",
            style: pw.TextStyle(
              fontSize: 5.5,
              fontWeight: isSelected ? pw.FontWeight.bold : pw.FontWeight.normal,
              color: isSelected ? PdfColors.red900 : PdfColors.black,
            ),
          ),
        );
      }),
      
      ...customOptions.where((c) => c.isNotEmpty).map((c) => pw.Container(
        child: pw.Text(
          "[X] ${c.trim()}",
          style: pw.TextStyle(
            fontSize: 5.5, 
            fontWeight: pw.FontWeight.bold, 
            color: PdfColors.red900,
          ),
        ),
      )),
    ],
  );
}

  static pw.Widget _buildMiniEvidences(BandaComponent c) {
    final allEvidences = [...c.evidenceBefore, ...c.evidenceAfter];
    if (allEvidences.isEmpty) return pw.SizedBox();

    return pw.Wrap(
      spacing: 2,
      runSpacing: 2,
      children: allEvidences
          .map(
            (e) => pw.Container(
              width: 12,
              height: 12,
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey),
              ),
              child: pw.Image(pw.MemoryImage(e.bytes), fit: pw.BoxFit.cover),
            ),
          )
          .toList(),
    );
  }

  static pw.Widget _buildTechnicalFooter(Map<String, dynamic> data, List<Roller> rodillos) {
    return pw.Table(
      border: pw.TableBorder.all(width: 1.0, color: _kBorderColor),
      columnWidths: {
        0: const pw.FlexColumnWidth(1), // COMENTARIOS más chico
        1: const pw.FlexColumnWidth(3), // RODILLOS ocupa más espacio
        2: const pw.FlexColumnWidth(1.2), // CROQUIS
      },
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: _kGreyHeader),
          children: [
            _cell("COMENTARIOS", bold: true),
            _cell("RODILLOS DAÑADOS", bold: true),
            _cell("CROQUIS", bold: true),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Container(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text(data['comentarios'] ?? "", style: const pw.TextStyle(fontSize: 6)),
            ),
            _buildRodillosDanadosTable(rodillos),
            pw.Container(),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildRodillosDanadosTable(List<Roller> datosRodillos) {
    // Usamos abreviaturas para que las columnas no se amontonen
    final headers = ["M", "B", "IZ", "CE", "DE", "IM", "RE", "SOP", "OBS"];

    return pw.Column(
      children: [
        pw.Table(
          border: pw.TableBorder.all(width: 0.5, color: _kBorderColor),
          columnWidths: {
            0: const pw.FixedColumnWidth(20), // Mesa
            1: const pw.FixedColumnWidth(20), // Base
            2: const pw.FixedColumnWidth(20), // IZQ
            3: const pw.FixedColumnWidth(20), // CEN
            4: const pw.FixedColumnWidth(20), // DER
            5: const pw.FixedColumnWidth(20), // IMP
            6: const pw.FixedColumnWidth(20), // RET
            7: const pw.FixedColumnWidth(40), // SOP
            8: const pw.FlexColumnWidth(1),   // OBS (ocupa lo que sobra)
          },
          children: [
            pw.TableRow(
              decoration: pw.BoxDecoration(color: _kGreyHeader),
              children: headers.map((h) => pw.Container(
                alignment: pw.Alignment.center,
                padding: const pw.EdgeInsets.symmetric(vertical: 2),
                child: pw.Text(h, style: pw.TextStyle(fontSize: 5, fontWeight: pw.FontWeight.bold)),
              )).toList(),
            ),
            ...datosRodillos.map((r) => pw.TableRow(
              children: [
                _cell(r.tableNumber.toString()),
                _cell(r.baseNumber.toString()),
                _cell(r.isLeft ? "1" : ""),
                _cell(r.isCenter ? "1" : ""),
                _cell(r.isRight ? "1" : ""),
                _cell(r.isImpact ? "1" : ""),
                _cell(r.isReturn ? "1" : ""),
                _cell(r.isTriple ? "T" : "A"), // Abrevia Triple/Auto
                _cell(r.observation),
              ],
            )).toList(),
          ],
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 4),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
            children: [
              _buildTotalBox("CARGA", "${datosRodillos.fold(0, (s, i) => s + (i.isLeft?1:0) + (i.isCenter?1:0) + (i.isRight?1:0))} PZ"),
              _buildTotalBox("IMP", "${datosRodillos.fold(0, (s, i) => s + (i.isImpact?1:0))} PZ"),
              _buildTotalBox("RET", "${datosRodillos.fold(0, (s, i) => s + (i.isReturn?1:0))} PZ"),
            ],
          ),
        ),
      ],
    );
  }

  

  // Helper para los cuadros de totales
  static pw.Widget _buildTotalBox(String label, String value) => pw.Column(
    children: [
      pw.Text(label, style: const pw.TextStyle(fontSize: 7)),
      pw.Text(
        "$value PZ",
        style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
      ),
    ],
  );
  static pw.Widget _cell(String text, {bool bold = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(2),
      alignment: pw.Alignment.center,
      child: pw.Text(
        text.isEmpty ? "-" : text, 
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          fontSize: 7,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }
}
