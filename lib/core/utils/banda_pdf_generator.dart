import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter/foundation.dart'; // <--- Esta línea define debugPrint
import 'package:pdf/widgets.dart' as pw;
import '../../features/bandas_transportadoras/domain/entities/roller.dart';
import '../../features/bandas_transportadoras/domain/entities/banda_template.dart';

class BandaPdfGenerator {
  static final _kBorderColor = PdfColors.black;
  static final _kGreyHeader = PdfColor.fromHex("#D3D3D5");

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
          ans.option?.id?.toString() ?? '',
          ans.option?.label?.toString() ?? '',
          ans.option?.value?.toString() ?? '',
        ],
        observation: ans.recommendedAction ?? '',
        // AQUÍ ESTABA EL ERROR: Agregamos la dimensión desde el modelo 'ans'
        dimentions: ans.dimentions?.toString() ?? '',
        evidenceBefore: ans.evidenceBefore ?? [],
        evidenceAfter: ans.evidenceAfter ?? [],
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
    debugPrint("Error al cargar imagen: $e");
  }

  // --- 1. PORTADA: Información General y Tablas Resumen ---
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.letter,
      margin: const pw.EdgeInsets.all(15),
      header: (context) => _buildFullHeader(fullHeaderImg),
      build: (context) => [
        _buildInfoGrid(data),
        pw.SizedBox(height: 5),
        _buildMainTable(sections),
        pw.SizedBox(height: 10),
        _buildTechnicalFooter(data, rodillos),
      ],
    ),
  );
for (var section in sections) {
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.letter,
      margin: const pw.EdgeInsets.all(15),
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildFullHeader(fullHeaderImg),
          pw.SizedBox(height: 10),
          _buildInfoGrid(data),
          pw.SizedBox(height: 15),
          // Aquí llamamos al desglose fijo
          pw.Expanded(child: _buildTablaDesglose(section)), 
        ],
      ),
    ),
  );
}
  if (rodillos.isNotEmpty) {
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.letter,
        margin: const pw.EdgeInsets.all(15),
        build: (context) => pw.Column(
          children: [
            _buildFullHeader(fullHeaderImg),
            pw.SizedBox(height: 10),
            pw.Text("DETALLE TÉCNICO DE RODILLERÍA", 
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
            pw.SizedBox(height: 10),
            _buildRodilleriaFullPage(data, rodillos), // <--- AQUÍ SE MUESTRA
          ],
        ),
      ),
    );
  }

  return pdf.save();
}
static pw.Widget _buildTablaDesglose(BandaSection section) {
  final componentesConDatos = section.components.where((c) => 
    (c.comment != null && c.comment!.trim().isNotEmpty) || 
    (c.observation.trim().isNotEmpty)
  ).toList();

  final mid = (componentesConDatos.length / 2).ceil();
  final leftGroup = componentesConDatos.sublist(0, mid);
  final rightGroup = componentesConDatos.sublist(mid);

  return pw.Column(
    children: [
      // 1. TABLA ÚNICA DE ACCESORIOS (SIN ANIDAR)
      pw.Table(
        border: pw.TableBorder.all(width: 0.5),
        columnWidths: {
          0: const pw.FlexColumnWidth(0.5), // SECCION
          1: const pw.FlexColumnWidth(0.9), // ACCESORIOS
          2: const pw.FlexColumnWidth(1.8), // OBSERVACIONES
          3: const pw.FlexColumnWidth(0.6), // DIMENSIONES
        },
        children: [
          pw.TableRow(decoration: pw.BoxDecoration(color: _kGreyHeader), children: [
            _cell("SECCION", bold: true),
            _cell("ACCESORIOS", bold: true),
            _cell("OBSERVACIONES", bold: true),
            _cell("DIMENSIONES", bold: true),
          ]),
          ...section.components.map((c) => pw.TableRow(
            children: [
              // La sección solo se pone en la primera fila o como prefieras
              pw.Container(alignment: pw.Alignment.center, padding: const pw.EdgeInsets.all(4), child: pw.Text(section.name.toUpperCase(), style:  pw.TextStyle(fontSize: 6, fontWeight: pw.FontWeight.bold))),
              pw.Container(padding: const pw.EdgeInsets.all(4), child: pw.Text(c.name, style: const pw.TextStyle(fontSize: 6))),
              pw.Container(padding: const pw.EdgeInsets.all(4), child: _buildOptionsInRow(c.options, c.selectedOptionIds, c.customOptions)),
              pw.Container(padding: const pw.EdgeInsets.all(4), child: pw.Text(c.dimentions, style: const pw.TextStyle(fontSize: 6))),
            ],
          )).toList(),
        ],
      ),

      pw.SizedBox(height: 10),

      pw.SizedBox(height: 10),

      // 2. TUS IMÁGENES, COMENTARIOS Y ACCIONES ABAJO
      pw.Table(
        border: pw.TableBorder.all(width: 0.5),
        columnWidths: {0: const pw.FlexColumnWidth(1), 1: const pw.FlexColumnWidth(1)},
        children: [
          pw.TableRow(decoration: pw.BoxDecoration(color: _kGreyHeader), children: [
            pw.Text("Imag.", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
            pw.Text("Imag.", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
          ]),
          pw.TableRow(children: [
            pw.Container(height: 250, padding: const pw.EdgeInsets.all(5), child: _renderComponentBlock(leftGroup)),
            pw.Container(height: 250, padding: const pw.EdgeInsets.all(5), child: _renderComponentBlock(rightGroup)),
          ]),
          pw.TableRow(decoration: pw.BoxDecoration(color: _kGreyHeader), children: [
            pw.Text("COMENTARIOS", style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold)),
            pw.Text("COMENTARIOS", style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold)),
          ]),
          pw.TableRow(children: [_buildComentariosPorSeccion(leftGroup), _buildComentariosPorSeccion(rightGroup)]),
          pw.TableRow(decoration: pw.BoxDecoration(color: _kGreyHeader), children: [
            pw.Text("ACCIONES", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
            pw.Text("ACCIONES", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
          ]),
          pw.TableRow(children: [
            pw.Container(height: 80, child: _buildAccionesPorSeccion(leftGroup)),
            pw.Container(height: 80, child: _buildAccionesPorSeccion(rightGroup)),
          ]),
        ],
      ),
    ],
  );
}
static pw.Widget _buildNestedTable(
    List<BandaComponent> components, {
    bool isNameColumn = false,
    bool isOptionsColumn = false,
    bool isRecomendacionColumn = false,
    bool isCommentColumn = false,
    bool isEvidenceColumn = false,
  }) {
    return pw.Table(
      border: pw.TableBorder(horizontalInside: const pw.BorderSide(width: 0.5)),
      children: components.map((c) {
        return pw.TableRow(
          children: [
            pw.Container(
              padding: const pw.EdgeInsets.all(5),
              // IMPORTANTE: Unificar la altura mínima para todas las columnas
              constraints: const pw.BoxConstraints(minHeight: 30), 
              alignment: pw.Alignment.centerLeft,
              child: isNameColumn 
                  ? pw.Text(c.name, style: const pw.TextStyle(fontSize: 6))
                  : isOptionsColumn 
                      ? _buildOptionsInRow(c.options, c.selectedOptionIds, c.customOptions)
                  : isRecomendacionColumn 
                      ? pw.Text(c.observation, style: const pw.TextStyle(fontSize: 6))
                  : isCommentColumn 
                      ? pw.Text(c.comment ?? "", style: const pw.TextStyle(fontSize: 6))
                  : _buildMiniEvidences(c),
            ),
          ],
        );
      }).toList(),
    );
  }
static pw.Widget _buildNestedTableColumn(List<BandaComponent> components, {required String type}) {
  return pw.Table(
    border: pw.TableBorder(horizontalInside: const pw.BorderSide(width: 0.5)),
    children: components.map((c) => pw.TableRow(children: [
      pw.Container(
        padding: const pw.EdgeInsets.all(4),
        child: type == 'name' 
            ? pw.Text(c.name, style: const pw.TextStyle(fontSize: 6))
            : type == 'obs' 
                ? _buildOptionsInRow(c.options, c.selectedOptionIds, c.customOptions)
                : pw.Text(c.dimentions, style: const pw.TextStyle(fontSize: 6)),
      ),
    ])).toList(),
  );
}

static pw.Widget _buildAccionesPorSeccion(List<BandaComponent> components) {
  final conAcciones = components.where((c) => c.observation.trim().isNotEmpty).toList();
  
  if (conAcciones.isEmpty) return pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text("-", style: const pw.TextStyle(fontSize: 7)));

  return pw.Padding(
    padding: const pw.EdgeInsets.all(5),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: conAcciones.map((c) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 4),
        child: pw.Text("${c.name.toUpperCase()}: ${c.observation}", style: const pw.TextStyle(fontSize: 7)),
      )).toList(),
    ),
  );
}
static pw.Widget _buildComentariosPorSeccion(List<BandaComponent> components) {
  final componentesConComentarios = components.where((c) => 
    c.comment != null && c.comment!.trim().isNotEmpty
  ).toList();

  if (componentesConComentarios.isEmpty) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text("Sin comentarios en esta sección.", style: const pw.TextStyle(fontSize: 7)),
    );
  }

  return pw.Padding(
    padding: const pw.EdgeInsets.all(5),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: componentesConComentarios.map((c) {
        return pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 4),
          child: pw.RichText(
            text: pw.TextSpan(
              children: [
                pw.TextSpan(
                  text: "${c.name.toUpperCase()}: ",
                  style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold),
                ),
                pw.TextSpan(
                  text: c.comment!,
                  style: const pw.TextStyle(fontSize: 7),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    ),
  );
}
static pw.Widget _renderComponentBlock(List<BandaComponent> components) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: components.map((c) {
      final allEvidences = [...c.evidenceBefore, ...c.evidenceAfter];
      if (allEvidences.isEmpty) return pw.SizedBox();

      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(c.name.toUpperCase(), style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 3),
          pw.Wrap(
            spacing: 5,
            runSpacing: 5,
            children: allEvidences.map((e) => pw.Container(
              width: 130, // Fotos más grandes
              height: 130,
              decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),
              child: pw.Image(pw.MemoryImage(e.bytes), fit: pw.BoxFit.cover),
            )).toList(),
          ),
          pw.SizedBox(height: 10),
        ],
      );
    }).toList(),
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
     0: const pw.FlexColumnWidth(0.6), // SECCION
      1: const pw.FlexColumnWidth(1.0), // ACCESORIOS
      2: const pw.FlexColumnWidth(2.0), // OBSERVACIONES
      3: const pw.FlexColumnWidth(0.8), // ACCIONES Y RECOMENDACIONES
      4: const pw.FlexColumnWidth(0.8), // COMENTARIOS <--- NUEVA
      5: const pw.FlexColumnWidth(0.5), // EVIDENCIA

      },
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: _kGreyHeader),
          children: [
            _cell("SECCION", bold: true),
            _cell("ACCESORIOS", bold: true),
            _cell("OBSERVACIONES", bold: true),
            _cell("ACCIONES Y RECOMENDACIONES", bold: true),
            _cell("COMENTARIOS.", bold: true), // <--- Título Columna
            _cell("EVIDENCIA.", bold: true),
          ],
        ),
        ...sections.map((s) {
          return pw.TableRow(
            children: [
           _cell(s.name, bold: true),
            _buildNestedTable(s.components, isNameColumn: true),
            _buildNestedTable(s.components, isOptionsColumn: true),
            _buildNestedTable(s.components, isRecomendacionColumn: true),
            _buildNestedTable(s.components, isCommentColumn: true), // <--- Nueva columna
            _buildNestedTable(s.components, isEvidenceColumn: true),
            ],
          );
        }).toList(),
      ],
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
  final headers = ["M", "B", "IZ", "CE", "DE", "IM", "RE", "SOP", "OBS"];

  // --- LÓGICA DE CÁLCULO EXACTA (IGUAL A RODILLERIASECTION) ---
  int nCarga = 0;
  int nImp = 0;
  int nRet = 0;

  for (var r in datosRodillos) {
    // Contamos cuántas posiciones activas tiene esta fila (1, 2 o 3)
    final int posicionesActivas = (r.isLeft ? 1 : 0) + (r.isCenter ? 1 : 0) + (r.isRight ? 1 : 0);
    
    // Aplicamos la misma lógica que en tu widget de inspección:
    if (r.isImpact) {
      nImp += posicionesActivas;
    } else if (r.isReturn) {
      nRet += posicionesActivas;
    } else {
      nCarga += posicionesActivas;
    }
  }

  return pw.Column(
    children: [
      pw.Table(
        border: pw.TableBorder.all(width: 0.5, color: _kBorderColor),
        // ... (Mantén tu columnWidths igual)
        columnWidths: {
          0: const pw.FixedColumnWidth(20), 1: const pw.FixedColumnWidth(20),
          2: const pw.FixedColumnWidth(20), 3: const pw.FixedColumnWidth(20),
          4: const pw.FixedColumnWidth(20), 5: const pw.FixedColumnWidth(20),
          6: const pw.FixedColumnWidth(20), 7: const pw.FixedColumnWidth(40),
          8: const pw.FlexColumnWidth(1),
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
              _cell(r.isTriple ? "T" : "A"),
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
            // USAMOS LAS VARIABLES CALCULADAS ARRIBA
            _buildTotalBox("CARGA", "$nCarga"),
            _buildTotalBox("IMP", "$nImp"),
            _buildTotalBox("RET", "$nRet"),
          ],
        ),
      ),
    ],
  );
}
static pw.Widget _buildRodilleriaFullPage(Map<String, dynamic> data, List<Roller> rodillos) {
  // 1. Cálculos de totales
  int nCarga = 0, nImp = 0, nRet = 0, nSop = 0;
  for (var r in rodillos) {
    final int posicionesActivas = (r.isLeft ? 1 : 0) + (r.isCenter ? 1 : 0) + (r.isRight ? 1 : 0);
    if (r.isImpact) nImp += posicionesActivas;
    else if (r.isReturn) nRet += posicionesActivas;
    else nCarga += posicionesActivas;
    if (r.isTriple) nSop += 1;
  }

  return pw.Column(
    children: [
      // 2. Información General (Igual que en la portada)
      _buildInfoGrid(data),
      pw.SizedBox(height: 10),

      // 3. Tabla Principal de Detalle
      pw.Table(
        border: pw.TableBorder.all(width: 0.5),
        columnWidths: {
          0: const pw.FixedColumnWidth(40), 
          1: const pw.FixedColumnWidth(40),
          ...List.generate(7, (i) => i + 2).asMap().map((k, v) => MapEntry(v, const pw.FlexColumnWidth(1))),
        },
        children: [
          pw.TableRow(decoration: pw.BoxDecoration(color: _kGreyHeader), children: [
            _cell("No. MESA", bold: true), _cell("No. BASE", bold: true),
            _cell("IZQ", bold: true), _cell("CEN", bold: true), _cell("DER", bold: true),
            _cell("IMPACTO", bold: true), _cell("RETORNO", bold: true), _cell("SOPORTE", bold: true),
          ]),
          ...List.generate(20, (index) {
            final r = index < rodillos.length ? rodillos[index] : null;
            return pw.TableRow(children: [
              _cell(r?.tableNumber.toString() ?? ""),
              _cell(r?.baseNumber.toString() ?? ""),
              _cell(r?.isLeft == true ? "1" : ""),
              _cell(r?.isCenter == true ? "1" : ""),
              _cell(r?.isRight == true ? "1" : ""),
              _cell(r?.isImpact == true ? "1" : ""),
              _cell(r?.isReturn == true ? "1" : ""),
              _cell(r?.isTriple == true ? "T" : "A"),
            ]);
          }),
        ],
      ),

      // 4. Cuadro de Totales (Amarillo)
      pw.Table(
        border: pw.TableBorder.all(width: 0.5),
        children: [
          pw.TableRow(decoration: pw.BoxDecoration(color: PdfColors.yellow), children: [
            _cell("DESCRIPCION DE RODILLO", bold: true),
            _cell("TOTAL", bold: true),
            _cell("UNIDAD", bold: true),
          ]),
          _resumenRow("RODILLO REPUESTO DE CARGA ACERO", "$nCarga"),
          _resumenRow("RODILLO REPUESTO DE IMPACTO DE CARGA", "$nImp"),
          _resumenRow("RODILLO REPUESTO DE RETORNO", "$nRet"),
          _resumenRow("SOPORTE TRIPLE DE CARGA", "$nSop"),
        ],
      ),

      // 5. Bloque de Notas (Roller Notes)
      pw.SizedBox(height: 10),
      pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.all(5),
        decoration: pw.BoxDecoration(border: pw.Border.all(width: 0.5)),
        child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text("COMENTARIOS DE RODILLERÍA:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8)),
          pw.Text(data['rollerNotes'] ?? "", style: const pw.TextStyle(fontSize: 7)),
        ]),
      ),

    ],
  );
}
static pw.TableRow _resumenRow(String desc, String total) => pw.TableRow(children: [
  _cell(desc), _cell(total, bold: true), _cell("PIEZA"),
]);
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
