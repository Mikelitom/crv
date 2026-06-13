import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../features/bandas_transportadoras/domain/entities/banda_template.dart';

class BandaPdfGenerator {
  static final _kBorderColor = PdfColors.black;
  static final _kGreyHeader = PdfColor.fromHex("#D3D3D3");

  static List<BandaOption> _obtenerOpcionesFijasParaComponente(String componentName) {
    final name = componentName.trim().toLowerCase();
    switch (name) {
      case 'banda en la polea':
        return [
          BandaOption(id: 'alineada', label: 'alineada', value: 'alineada'),
          BandaOption(id: 'desalineada', label: 'desalineada', value: 'desalineada'),
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
          BandaOption(id: 'recubierta', label: 'recubierta', value: 'recubierta'),
          BandaOption(id: 'cristalizada', label: 'cristalizada', value: 'cristalizada'),
          BandaOption(id: 'jaula_de_ardilla', label: 'jaula de ardilla', value: 'jaula de ardilla'),
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
          BandaOption(id: 'desgastados', label: 'desgastados', value: 'desgastados'),
          BandaOption(id: 'no_tiene', label: 'no tiene', value: 'no_tiene'),
        ];
      case 'carga en la banda':
        return [
          BandaOption(id: 'al_centro', label: 'al centro', value: 'al centro'),
          BandaOption(id: 'descentrada', label: 'descentrada', value: 'descentrada'),
          BandaOption(id: 'derrames', label: 'derrames', value: 'derrames'),
        ];
      case 'faldón metálico':
        return [
          BandaOption(id: 'al_%', label: 'al %', value: 'al %'),
          BandaOption(id: 'más_abierto', label: 'más abierto', value: 'más abierto'),
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
          BandaOption(id: 'buen_estado', label: 'buen estado', value: 'buen estado'),
          BandaOption(id: 'desgastada', label: 'desgastada', value: 'desgastada'),
          BandaOption(id: 'rayada', label: 'rayada', value: 'rayada'),
          BandaOption(id: 'cristalizada', label: 'cristalizada', value: 'cristalizada'),
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
          BandaOption(id: 'existentes', label: 'existentes', value: 'existentes'),
          BandaOption(id: 'por_reparar', label: 'por reparar', value: 'por reparar'),
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
          BandaOption(id: 'sin_maracas', label: 'sin maracas', value: 'sin maracas'),
          BandaOption(id: 'bloqueados', label: 'bloqueados', value: 'bloqueados'),
          BandaOption(id: 'cambiar', label: 'cambiar', value: 'cambiar'),
        ];
      case 'polea de cabeza':
        return [
          BandaOption(id: 'lisa', label: 'lisa', value: 'lisa'),
          BandaOption(id: 'recubierta', label: 'recubierta', value: 'recubierta'),
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
          BandaOption(id: 'secundarios', label: 'secundarios', value: 'secundarios'),
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
          BandaOption(id: 'adherencias', label: 'adherencias', value: 'adherencias'),
        ];
      case 'modificar':
        return [
          BandaOption(id: 'frontis', label: 'frontis', value: 'frontis'),
          BandaOption(id: 'laterales', label: 'laterales', value: 'laterales'),
          BandaOption(id: 'tolva_de_finos', label: 'tolva de finos', value: 'tolva de finos'),
          BandaOption(id: 'rediseñar', label: 'rediseñar', value: 'rediseñar'),
        ];
      case 'tolva de finos':
        return [
          BandaOption(id: 'limpia', label: 'limpia', value: 'limpia'),
          BandaOption(id: 'entortadas', label: 'entortadas', value: 'entortadas'),
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
          BandaOption(id: 'recubierta', label: 'recubierta', value: 'recubierta'),
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
          BandaOption(id: 'entortados', label: 'entortados', value: 'entortados'),
          BandaOption(id: 'ahogados', label: 'ahogados', value: 'ahogados'),
          BandaOption(id: 'cambiar', label: 'cambiar', value: 'cambiar'),
        ];
      case 'rodillos autoalineables':
        return [
          BandaOption(id: 'hay', label: 'hay', value: 'hay'),
          BandaOption(id: 'no_hay', label: 'no hay', value: 'no_hay'),
          BandaOption(id: 'sin_maracas', label: 'sin maracas', value: 'sin maracas'),
          BandaOption(id: 'bloqueados', label: 'bloqueados', value: 'bloqueados'),
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
          BandaOption(id: 'desalineadas', label: 'desalineadas', value: 'desalineadas'),
        ];
      case 'banda en la polea de contrapeso':
        return [
          BandaOption(id: 'alineada', label: 'alineada', value: 'alineada'),
          BandaOption(id: 'desalineadas', label: 'desalineadas', value: 'desalineadas'),
        ];
      case 'poleas de dobles':
        return [
          BandaOption(id: 'lisas', label: 'lisas', value: 'lisas'),
          BandaOption(id: 'recubiertas', label: 'recubiertas', value: 'recubiertas'),
          BandaOption(id: 'limpias', label: 'limpias', value: 'limpias'),
          BandaOption(id: 'cristalizada', label: 'cristalizada', value: 'cristalizada'),
          BandaOption(id: 'cambiar', label: 'cambiar', value: 'cambiar'),
        ];
      case 'polea de contrapeso':
        return [
          BandaOption(id: 'lisa', label: 'lisa', value: 'lisa'),
          BandaOption(id: 'recubiertas', label: 'recubiertas', value: 'recubiertas'),
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

  static Future<Uint8List> generateReport(
    Map<String, dynamic> data,
    List<BandaSection> sections,
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
          _buildInfoGrid(data),
          pw.SizedBox(height: 5),
          _buildMainTable(sections),
          pw.SizedBox(height: 10),
          _buildTechnicalFooter(data),
        ],
      ),
    );
    return pdf.save();
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
        _infoRow("RESPONSABLE:", data['responsable'], "SECCIÓN:", data['seccion']),
        _infoRow("FECHA:", data['fecha'], "TRANSPORTADOR:", data['transportador']),
        _infoRow("BANDA RECOMENDADA:", data['banda'], "MATERIAL Y GRANULOMETRÍA:", data['material']),
        _infoRow("ELABORÓ:", data['elaboro'], "PRESENTAR A:", data['presentar']),
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
        0: const pw.FixedColumnWidth(52), 
        1: const pw.FixedColumnWidth(100), 
        2: const pw.FlexColumnWidth(0.5), 
        3: const pw.FlexColumnWidth(0.3), 
        4: const pw.FixedColumnWidth(58), 
      },
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: _kGreyHeader),
          children: [
            _cell("SECCION", bold: true),
            _cell("ACCESORIOS", bold: true),
            _cell("OBSERVACIONES", bold: true),
            _cell("ACCIONES Y RECOMENDACIONES", bold: true),
            _cell("EVIDENCIAS", bold: true),
          ],
        ),
        ...sections.map((s) {
          return pw.TableRow(
            children: [
              pw.Container(
                padding: const pw.EdgeInsets.all(5),
                alignment: pw.Alignment.center,
                child: pw.Text(
                  s.name,
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 7.5,
                  ),
                ),
              ),
              pw.Column(
                children: s.components.map((c) => pw.Container(
                  height: 14,
                  padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                  alignment: pw.Alignment.centerLeft,
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(bottom: pw.BorderSide(width: 0.5)),
                  ),
                  child: pw.Text(c.name, style: const pw.TextStyle(fontSize: 5.5)),
                )).toList(),
              ),
              pw.Column(
                children: s.components.map((c) {
                  print("COMPONENTE: ${c.name}");
                  
                  for (final o in c.options) {
                      print("opt.id = ${o.id}");
                      print("opt.label = ${o.label}");
                    
                  }
                  final opcionesFijas = c.options.isNotEmpty
                      ? c.options
                      : _obtenerOpcionesFijasParaComponente(c.name);

                  print("SELECTED RAW: ${c.selectedOptionId}");
                  print("OPTIONS IDS: ${c.options.map((e) => e.id).toList()}");
                  
                  return pw.Container(
                    height: 14,
                    padding: const pw.EdgeInsets.symmetric(horizontal: 8),
                    alignment: pw.Alignment.centerLeft,
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(bottom: pw.BorderSide(width: 0.5)),
                    ),
                    child: _buildOptionsInRow(
                      opcionesFijas,
                      opcionesFijas.isEmpty ? c.selectedOptionId : c.selectedOptionId,
                      fallbackLabel: opcionesFijas.isEmpty ? c.name.trim().toLowerCase() : null,
                    ),
                  );
                }).toList(),
              ),
              pw.Column(
                children: s.components.map((c) => pw.Container(
                  height: 14,
                  padding: const pw.EdgeInsets.symmetric(horizontal: 4),
                  alignment: pw.Alignment.centerLeft,
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(bottom: pw.BorderSide(width: 0.5)),
                  ),
                  child: pw.Text(c.observation, style: const pw.TextStyle(fontSize: 6.5)),
                )).toList(),
              ),
              pw.Column(
                children: s.components.map((c) => pw.Container(
                  height: 14,
                  alignment: pw.Alignment.center,
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(bottom: pw.BorderSide(width: 0.5)),
                  ),
                  child: _buildMiniEvidences(c),
                )).toList(),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }

  // static pw.Widget _rowContainer(pw.Widget child) {
  //   return pw.Container(
  //     height: 14,
  //     padding: const pw.EdgeInsets.symmetric(horizontal: 5),
  //     alignment: pw.Alignment.centerLeft,
  //     decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 0.5))),
  //     child: child,
  //   );
  // }

  static pw.Widget _buildOptionsInRow(
    List<BandaOption> options,
    String? selectedValue,
    {String? fallbackLabel}
  ) {
    if (options.isEmpty) {
      return pw.Text("-", style: const pw.TextStyle(fontSize: 6));
    }

    print("------ PDF DEBUG ------");
    print("options length: ${options.length}");
    print("selectedValue: $selectedValue");
    print("fallbackLabel: $fallbackLabel");

    const incisos = ['a)', 'b)', 'c)', 'd)', 'e)', 'f)'];
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: List.generate(options.length, (index) {
        final opt = options[index];
        final selected = selectedValue?.trim().toLowerCase();
        
        final isSelected = options.isNotEmpty
            ? opt.id.trim() == selected
            : opt.label.trim().toLowerCase() == selected;
        
        return pw.Padding(
          padding: const pw.EdgeInsets.only(right: 15),
          child: pw.Text(
            "${incisos[index]} ${opt.label.trim()}",
            style: pw.TextStyle(
              fontSize: 5.5,
              fontWeight: isSelected ? pw.FontWeight.bold : pw.FontWeight.normal,
              decoration: isSelected ? pw.TextDecoration.underline : null,
              color: isSelected ? PdfColors.red900 : PdfColors.black,
            ),
          ),
        );
      }),
    );
  }

  static pw.Widget _buildMiniEvidences(BandaComponent c) {
    final allEvidences = [...c.evidenceBefore, ...c.evidenceAfter];
    if (allEvidences.isEmpty) return pw.SizedBox();
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      children: allEvidences.take(2).map((e) => pw.Padding(
        padding: const pw.EdgeInsets.all(4),
        child: pw.Container(
          width: 15,
          height: 15,
          child: pw.Image(pw.MemoryImage(e.bytes), fit: pw.BoxFit.cover),
        ),
      )).toList(),
    );
  }

  static pw.Widget _buildTechnicalFooter(Map<String, dynamic> data) {
    return pw.Table(
      border: pw.TableBorder.all(width: 1.0, color: _kBorderColor),
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(1),
        2: const pw.FlexColumnWidth(1.5),
      },
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: _kGreyHeader),
          children: [
            _cell("COMENTARIOS", bold: true),
            _cell("RODILLOS DANADOS", bold: true),
            _cell("CROQUIS DEL TRANSPORTADOR", bold: true),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Container(
              height: 40,
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text(
                data['comentarios'] ?? "",
                style: const pw.TextStyle(fontSize: 7),
              ),
            ),
            _buildRodillosDanadosTable(),
            pw.Container(height: 45),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildRodillosDanadosTable() {
    final list = ['STC20°', 'STC35°', 'STI', 'STA', 'SR', 'SRA', 'Maracas'];
    return pw.Table(
      border: pw.TableBorder.all(width: 0.5, color: _kGreyHeader),
      children: list.map((item) => pw.TableRow(
        children: [
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
            child: pw.Text(item, style: const pw.TextStyle(fontSize: 6)),
          ),
          pw.Container(width: 25, height: 10),
        ],
      )).toList(),
    );
  }

  static pw.Widget _cell(String text, {bool bold = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(2),
      alignment: pw.Alignment.center,
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          fontSize: 7,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }
}