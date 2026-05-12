import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../features/bandas_transportadoras/domain/entities/banda_template.dart';

class BandaPdfGenerator {
  static final _kBorderColor = PdfColors.black;
  static final _kGreyHeader = PdfColors.grey200;

  static Future<Uint8List> generateReport(Map<String, dynamic> data, List<BandaSection> sections) async {
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
        pageFormat: PdfPageFormat.letter.landscape,
        margin: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 15), 
        header: (context) => _buildFullHeader(fullHeaderImg),
        build: (context) => [
          _buildInfoGrid(data),
          _buildMainTable(sections),
          _buildTechnicalFooter(data),
        ],
      ),
    );
    return pdf.save();
  }

  static pw.Widget _buildFullHeader(pw.ImageProvider? img) {
    return pw.Container(
      decoration: pw.BoxDecoration(border: pw.Border.all(color: _kBorderColor, width: 1)),
      child: pw.Column(
        children: [
          if (img != null) 
            pw.Container(
              width: double.infinity,
              height: 75, // AJUSTE: Un poco mas alta para que quepa mejor
              child: pw.Image(img, fit: pw.BoxFit.contain), // AJUSTE: contain para no deformar
            ),
          pw.Container(
            width: double.infinity,
            decoration: pw.BoxDecoration(
              color: _kGreyHeader,
              border: pw.Border(top: pw.BorderSide(color: _kBorderColor, width: 1))
            ),
            padding: const pw.EdgeInsets.symmetric(vertical: 3),
            child: pw.Text(
              "REPORTE DE INSPECCION DE BANDA TRANSPORTADORA", 
              textAlign: pw.TextAlign.center, 
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)
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
        3: const pw.FlexColumnWidth(2)
      },
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
    return pw.TableRow(children: [
      pw.Container(color: _kGreyHeader, padding: const pw.EdgeInsets.all(3), child: pw.Text(l1, textAlign: pw.TextAlign.right, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 6.5))),
      pw.Padding(padding: const pw.EdgeInsets.all(3), child: pw.Text(v1?.toString() ?? "", style: const pw.TextStyle(fontSize: 7))),
      pw.Container(color: _kGreyHeader, padding: const pw.EdgeInsets.all(3), child: pw.Text(l2, textAlign: pw.TextAlign.right, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 6.5))),
      pw.Padding(padding: const pw.EdgeInsets.all(3), child: pw.Text(v2?.toString() ?? "", style: const pw.TextStyle(fontSize: 7))),
    ]);
  }

  static pw.Widget _buildMainTable(List<BandaSection> sections) {
    return pw.Table(
      border: pw.TableBorder.all(width: 1.0, color: _kBorderColor),
      columnWidths: {
        0: const pw.FixedColumnWidth(40), 
        1: const pw.FixedColumnWidth(110), 
        2: const pw.FlexColumnWidth(),   
        3: const pw.FixedColumnWidth(110), 
        4: const pw.FixedColumnWidth(60), // NUEVA COLUMNA: Evidencias
      },
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: _kGreyHeader),
          children: [
            _cell("SECCION", bold: true),
            _cell("ACCESORIOS", bold: true),
            _cell("OBSERVACIONES", bold: true),
            _cell("ACCIONES Y RECOMENDACIONES", bold: true),
            _cell("EVIDENCIAS", bold: true), // TITULO NUEVA COLUMNA
          ],
        ),
        ...sections.map((s) {
          return pw.TableRow(
            children: [
              pw.Container(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Center(child: pw.Text(s.name, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 7.5))),
              ),
              pw.Column(
                children: s.components.map((c) => pw.Container(
                  height: 22,
                  padding: const pw.EdgeInsets.symmetric(horizontal: 4),
                  alignment: pw.Alignment.centerLeft,
                  decoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: _kBorderColor, width: 0.5))),
                  child: pw.Text(c.name, style: const pw.TextStyle(fontSize: 7)),
                )).toList(),
              ),
              pw.Column(
                children: s.components.map((c) => pw.Container(
                  height: 22,
                  padding: const pw.EdgeInsets.symmetric(horizontal: 4),
                  decoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: _kBorderColor, width: 0.5))),
                  child: _buildOptionsInRow(c),
                )).toList(),
              ),
              pw.Column(
                children: s.components.map((c) => pw.Container(
                  height: 22,
                  padding: const pw.EdgeInsets.symmetric(horizontal: 4),
                  alignment: pw.Alignment.centerLeft,
                  decoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: _kBorderColor, width: 0.5))),
                  child: pw.Text(c.observation, style: const pw.TextStyle(fontSize: 6.5)),
                )).toList(),
              ),
              // NUEVA CELDA: Miniaturas de evidencias
              pw.Column(
                children: s.components.map((c) => pw.Container(
                  height: 22,
                  decoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: _kBorderColor, width: 0.5))),
                  child: _buildMiniEvidences(c),
                )).toList(),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }

  static pw.Widget _buildOptionsInRow(BandaComponent c) {
    const incisos = ['a)', 'b)', 'c)', 'd)', 'e)', 'f)'];
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: List.generate(c.options.length, (index) {
        final opt = c.options[index];
        final bool isSelected = opt.id == c.selectedOptionId;
        return pw.Padding(
          padding: const pw.EdgeInsets.only(right: 6),
          child: pw.Text(
            "${incisos[index]} ${opt.label}",
            style: pw.TextStyle(
              fontSize: 5.8,
              fontWeight: isSelected ? pw.FontWeight.bold : pw.FontWeight.normal,
              decoration: isSelected ? pw.TextDecoration.underline : null,
              color: isSelected ? PdfColors.red900 : PdfColors.black, // AJUSTE: Color ROJO para seleccion
            ),
          ),
        );
      }),
    );
  }

  // FUNCION PARA DIBUJAR MINI FOTOS
  static pw.Widget _buildMiniEvidences(BandaComponent c) {
    final allEvidences = [...c.evidenceBefore, ...c.evidenceAfter];
    if (allEvidences.isEmpty) return pw.SizedBox();
    
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      children: allEvidences.take(2).map((e) => pw.Padding(
        padding: const pw.EdgeInsets.all(1),
        child: pw.Container(
          width: 15, height: 15,
          child: pw.Image(pw.MemoryImage(e.bytes), fit: pw.BoxFit.cover)
        )
      )).toList()
    );
  }

  static pw.Widget _buildTechnicalFooter(Map<String, dynamic> data) {
    return pw.Table(
      border: pw.TableBorder.all(width: 1.0, color: _kBorderColor),
      columnWidths: {0: const pw.FlexColumnWidth(2), 1: const pw.FlexColumnWidth(1), 2: const pw.FlexColumnWidth(1.5)},
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
            pw.Container(height: 70, padding: const pw.EdgeInsets.all(5), child: pw.Text(data['comentarios'] ?? "", style: const pw.TextStyle(fontSize: 7))),
            _buildRodillosDanadosTable(), 
            pw.Container(height: 70), 
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildRodillosDanadosTable() { 
    final list = ['STC20°', 'STC35°', 'STI', 'STA', 'SR', 'SRA', 'Maracas'];
    return pw.Table(
      border: pw.TableBorder.all(width: 0.5, color: _kBorderColor),
      children: list.map((item) => pw.TableRow(
        children: [
          pw.Container(padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 1.5), child: pw.Text(item, style: const pw.TextStyle(fontSize: 6))),
          pw.Container(width: 25, height: 10),
        ],
      )).toList(),
    );
  }

  static pw.Widget _cell(String t, {bool bold = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(4),
      alignment: pw.Alignment.center,
      child: pw.Text(t, textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 7, fontWeight: bold ? pw.FontWeight.bold : null)),
    );
  }
}