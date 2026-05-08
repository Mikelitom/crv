import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../features/bandas_transportadoras/domain/entities/banda_template.dart';

class BandaPdfGenerator {
  static final _kRed = PdfColor.fromHex('#B71C1C');
  static final _kGrey = PdfColor.fromHex('#E0E0E0');

  static Future<Uint8List> generateReport(Map<String, dynamic> data, List<BandaSection> sections) async {
    final pdf = pw.Document();
    
    pw.ImageProvider? fullHeaderImage;
    try {
      // Carga de la imagen que contiene el encabezado completo (Logos y Títulos)
      fullHeaderImage = pw.MemoryImage(
        (await rootBundle.load('assets/images/bandas_pdf.png')).buffer.asUint8List(),
      );
    } catch (e) {
      print("Error: No se pudo cargar assets/images/bandas_pdf.png");
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter.landscape,
        margin: const pw.EdgeInsets.all(20.0),
        // HEADER: La imagen completa tal cual la pediste
        header: (context) => _buildFullImageHeader(fullHeaderImage),
        build: (context) => [
          _buildInfoGrid(data),
          pw.SizedBox(height: 5.0),
          _buildInspectionTable(sections),
          pw.SizedBox(height: 5.0),
          _buildFooterTechnical(data), // Nombre corregido aquí
          pw.NewPage(), 
          _buildEvidenceGallery(sections),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildFullImageHeader(pw.ImageProvider? image) {
    if (image == null) return pw.SizedBox(height: 80.0);
    return pw.Container(
      width: double.infinity,
      height: 90.0, 
      margin: const pw.EdgeInsets.only(bottom: 10.0),
      child: pw.Image(image, fit: pw.BoxFit.contain),
    );
  }

  static pw.Widget _buildInfoGrid(Map<String, dynamic> data) {
    return pw.Table(
      border: pw.TableBorder.all(),
      children: [
        _infoRow("PLANTA:", data['planta'], "AREA:", data['area']),
        _infoRow("RESPONSABLE:", data['responsable'], "SECCION:", data['seccion']),
        _infoRow("FECHA:", data['fecha'], "TRANSPORTADOR:", data['transportador']),
        _infoRow("BANDA RECOMENDADA:", data['banda'], "MATERIAL Y GRANULOMETRIA:", data['material']),
        _infoRow("ELABORO:", data['elaboro'], "PRESENTAR A:", data['presentar']),
      ],
    );
  }

  static pw.TableRow _infoRow(String l1, dynamic v1, String l2, dynamic v2) {
    return pw.TableRow(
      children: [
        _cell(l1, bg: PdfColors.grey300, bold: true, align: pw.TextAlign.left, fontSize: 6.5),
        _cell(v1?.toString() ?? "", align: pw.TextAlign.left, fontSize: 7.0),
        _cell(l2, bg: PdfColors.grey300, bold: true, align: pw.TextAlign.left, fontSize: 6.5),
        _cell(v2?.toString() ?? "", align: pw.TextAlign.left, fontSize: 7.0),
      ],
    );
  }

  static pw.Widget _buildInspectionTable(List<BandaSection> sections) {
    return pw.Table(
      border: pw.TableBorder.all(),
      columnWidths: {
        0: const pw.FixedColumnWidth(25.0), // SECCION Lateral
        1: const pw.FixedColumnWidth(95.0), // ACCESORIOS
        2: const pw.FlexColumnWidth(3.0),   // OBSERVACIONES a, b, c...
        3: const pw.FixedColumnWidth(130.0), // RECOMENDACIONES
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey400),
          children: [
            _cell("SECCION", bold: true, fontSize: 7.0),
            _cell("ACCESORIOS", bold: true, fontSize: 7.0),
            _cell("OBSERVACIONES (Respuesta en Rojo)", bold: true, fontSize: 7.0),
            _cell("ACCIONES Y RECOMENDACIONES", bold: true, fontSize: 7.0),
          ],
        ),
        ...sections.expand((section) {
          return List.generate(section.components.length, (index) {
            final comp = section.components[index];
            return pw.TableRow(
              children: [
                index == 0 
                  ? pw.Container(
                      height: 50.0, 
                      alignment: pw.Alignment.center, 
                      child: pw.Transform.rotate(
                        angle: 1.57, 
                        child: pw.Text(section.name.toUpperCase(), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8.0))
                      )
                    )
                  : pw.Container(),
                _cell(comp.name, align: pw.TextAlign.left, bold: true, fontSize: 7.0),
                _buildOptionsCell(comp),
                _cell(comp.observation ?? "", align: pw.TextAlign.left, fontSize: 7.0),
              ],
            );
          });
        }).toList(),
      ],
    );
  }

  static pw.Widget _buildOptionsCell(BandaComponent comp) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4.0),
      child: pw.Wrap(
        spacing: 12.0, runSpacing: 3.0,
        children: comp.options.map((opt) {
          final bool isSelected = opt.id == comp.selectedOptionId;
          return pw.Text(
            opt.label, 
            style: pw.TextStyle(
              fontSize: 7.5,
              color: isSelected ? _kRed : PdfColors.black,
              fontWeight: isSelected ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          );
        }).toList(),
      ),
    );
  }

  static pw.Widget _buildEvidenceGallery(List<BandaSection> sections) {
    final itemsConFoto = sections
        .expand((s) => s.components)
        .where((c) => c.evidenceBefore.isNotEmpty || c.evidenceAfter.isNotEmpty)
        .toList();

    return pw.Column(
      children: [
        pw.Center(child: pw.Text("ANEXO: EVIDENCIAS FOTOGRÁFICAS", style: pw.TextStyle(fontSize: 14.0, fontWeight: pw.FontWeight.bold, color: _kRed))),
        pw.SizedBox(height: 15.0),
        ...itemsConFoto.map((comp) => pw.Column(
          children: [
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(6.0),
              color: PdfColors.grey200,
              child: pw.Text("ACCESORIO: ${comp.name}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
            ),
            pw.SizedBox(height: 10.0),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                _buildImageBox("FOTO ANTES", comp.evidenceBefore),
                _buildImageBox("FOTO DESPUÉS", comp.evidenceAfter),
              ],
            ),
            pw.SizedBox(height: 25.0),
          ],
        )).toList(),
      ],
    );
  }

  static pw.Widget _buildImageBox(String title, List<EvidenceFile> files) {
    return pw.Column(
      children: [
        pw.Text(title, style: pw.TextStyle(fontSize: 8.0, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 6.0),
        pw.Container(
          width: 270.0, height: 180.0,
          decoration: pw.BoxDecoration(border: pw.Border.all(color: _kRed, width: 2.5)), 
          child: files.isNotEmpty 
            ? pw.Image(pw.MemoryImage(files.first.bytes), fit: pw.BoxFit.cover)
            : pw.Center(child: pw.Text("Sin evidencia", style: const pw.TextStyle(fontSize: 7.0, color: PdfColors.grey))),
        ),
      ],
    );
  }

  static pw.Widget _buildFooterTechnical(Map<String, dynamic> data) {
    return pw.Table(
      border: pw.TableBorder.all(),
      columnWidths: {
        0: const pw.FlexColumnWidth(2.0),
        1: const pw.FixedColumnWidth(90.0),
        2: const pw.FlexColumnWidth(2.0),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey400),
          children: [
            _cell("COMENTARIOS", bold: true, fontSize: 7.0),
            _cell("RODILLOS", bold: true, fontSize: 7.0),
            _cell("CROQUIS DEL TRANSPORTADOR", bold: true, fontSize: 7.0),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Container(height: 55.0, padding: const pw.EdgeInsets.all(6.0), child: pw.Text(data['comentarios'] ?? "", style: const pw.TextStyle(fontSize: 7.5))),
            _buildRodillosTable(),
            pw.Container(height: 55.0),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildRodillosTable() {
    final rodillos = ["STC20", "STC35", "STI", "STA", "SR", "SRA", "Maracas"];
    return pw.Table(
      border: pw.TableBorder.all(),
      children: rodillos.map((r) => pw.TableRow(
        children: [
          pw.Padding(padding: const pw.EdgeInsets.all(1.0), child: pw.Text(r, style: pw.TextStyle(fontSize: 5.5, fontWeight: pw.FontWeight.bold))),
          pw.Padding(padding: const pw.EdgeInsets.all(1.0), child: pw.Text("", style: const pw.TextStyle(fontSize: 5.5))),
        ]
      )).toList(),
    );
  }

  static pw.Widget _cell(String text, {PdfColor? bg, bool bold = false, pw.TextAlign align = pw.TextAlign.center, double fontSize = 7.5}) {
    return pw.Container(
      color: bg,
      padding: const pw.EdgeInsets.all(4.5),
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(
          fontSize: fontSize, 
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal
        ),
      ),
    );
  }
}