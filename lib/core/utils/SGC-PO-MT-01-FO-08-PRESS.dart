import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PrensaPdfGenerator {
  static String generateFileName(Map<String, dynamic> data) {
    final String serie = data['serie'] ?? "SN";
    final String fecha = data['fecha'] ?? "SF";
    return "SGC-PO-MT-01-FO-08-$serie-$fecha.pdf";
  }

  static Future<Uint8List> generateEsqueleto(Map<String, dynamic> data) async {
    final pdf = pw.Document();
    pw.ImageProvider? logoImage;
    pw.ImageProvider? pressImage;

    try {
      logoImage = pw.MemoryImage((await rootBundle.load('assets/images/logo_reprosisa.png')).buffer.asUint8List());
      pressImage = pw.MemoryImage((await rootBundle.load('assets/images/press.png')).buffer.asUint8List());
    } catch (e) {
      print("Error cargando assets: $e");
    }

    final List<dynamic> itemsProcesados = [];
    for (var item in (data['items'] as List<dynamic>)) {
      Map<String, dynamic> itemCopia = Map<String, dynamic>.from(item);
      if (item['foto_antes_bytes'] != null) {
        itemCopia['foto_antes_provider'] = pw.MemoryImage(item['foto_antes_bytes']);
      }
      if (item['foto_despues_bytes'] != null) {
        itemCopia['foto_despues_provider'] = pw.MemoryImage(item['foto_despues_bytes']);
      }
      itemsProcesados.add(itemCopia);
    }

    final List<dynamic> itemsConEvidencia = itemsProcesados
        .where((item) => item['foto_antes_provider'] != null || item['foto_despues_provider'] != null)
        .toList();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter, // VERTICAL
        margin: const pw.EdgeInsets.all(20),
        header: (context) => _buildSgcHeader(logoImage),
        build: (pw.Context context) => [
          pw.SizedBox(height: 10),
          _buildGeneralInfoBox(data, pressImage),
          pw.SizedBox(height: 10),
          _buildInspectionTable(itemsProcesados),
          pw.SizedBox(height: 10),
          _buildLoanFooterSection(data),
          if (itemsConEvidencia.isNotEmpty) ...[
            pw.NewPage(),
            pw.Center(child: pw.Text("ANEXO DE EVIDENCIAS FOTOGRÁFICAS", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.red900))),
            pw.SizedBox(height: 15),
            ...itemsConEvidencia.map((item) => _buildComponentEvidenciaGrande(item)),
          ]
        ],
      ),
    );
    return pdf.save();
  }

  static pw.Widget _buildSgcHeader(pw.ImageProvider? logo) {
    return pw.Table(
      border: pw.TableBorder.all(width: 1),
      columnWidths: {0: const pw.FixedColumnWidth(100), 1: const pw.FlexColumnWidth(), 2: const pw.FixedColumnWidth(130)},
      children: [
        pw.TableRow(children: [
          pw.Container(height: 50, alignment: pw.Alignment.center, child: logo != null ? pw.Image(logo, width: 80) : pw.SizedBox()),
          pw.Column(children: [
            pw.Container(padding: const pw.EdgeInsets.all(2), child: pw.Text("RECUBRIMIENTOS, PRODUCTOS Y SERVICIOS INDUSTRIALES, S.A. DE C.V.", textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold))),
            pw.Divider(height: 1),
            pw.Container(padding: const pw.EdgeInsets.all(2), child: pw.Text("SISTEMA DE GESTIÓN DE CALIDAD", textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold))),
            pw.Divider(height: 1),
            pw.Container(padding: const pw.EdgeInsets.all(2), child: pw.Text("CHECK LIST DE PRENSAS", textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold))),
          ]),
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            _hControlText("Código: SGC-PO-MT-01-FO-08"),
            pw.Divider(height: 1),
            _hControlText("Fecha emisión: 15/09/2022"),
          ]),
        ]),
      ],
    );
  }

  static pw.Widget _hControlText(String text) => pw.Padding(padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2), child: pw.Text(text, style: pw.TextStyle(fontSize: 6, fontWeight: pw.FontWeight.bold)));

  static pw.Widget _buildGeneralInfoBox(Map<String, dynamic> data, pw.ImageProvider? pressImg) {
    return pw.Container(
      decoration: pw.BoxDecoration(border: pw.Border.all(width: 1)),
      child: pw.Row(children: [
        pw.Expanded(flex: 3, child: pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Column(children: [
          _infoLine("Fecha inspección", data['fecha'] ?? "", area: data['area'] ?? ""),
          _infoLineSimple("Tipo", data['tipo'] ?? ""),
          _infoLineSimple("Modelo", data['modelo'] ?? ""),
          _infoLineSimple("VOLTS", data['volts'] ?? ""),
          _infoLineSimple("Serie", data['serie'] ?? "")
        ]))),
        pw.Expanded(flex: 1, child: pressImg != null ? pw.Container(height: 70, padding: const pw.EdgeInsets.all(5), child: pw.Image(pressImg, fit: pw.BoxFit.contain)) : pw.SizedBox()),
      ]),
    );
  }

  static pw.Widget _infoLine(String label, String val, {String area = ""}) => pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 2),
    child: pw.Row(children: [
      pw.Text("$label: ", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
      pw.Expanded(child: pw.Container(decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 0.5))), child: pw.Text(val, style: const pw.TextStyle(fontSize: 8)))),
      pw.Text(" Área: ", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
      pw.Expanded(child: pw.Container(decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 0.5))), child: pw.Text(area, style: const pw.TextStyle(fontSize: 8))))
    ]),
  );

  static pw.Widget _infoLineSimple(String label, String val) => pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 2),
    child: pw.Row(children: [
      pw.SizedBox(width: 60, child: pw.Text("$label: ", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold))),
      pw.Expanded(child: pw.Container(decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 0.5))), child: pw.Text(val, style: const pw.TextStyle(fontSize: 8))))
    ]),
  );

  static pw.Widget _buildInspectionTable(List<dynamic> items) {
    return pw.Table(
      border: pw.TableBorder.all(width: 0.8),
      columnWidths: {
        0: const pw.FixedColumnWidth(25), 1: const pw.FixedColumnWidth(30), 2: const pw.FlexColumnWidth(3),
        3: const pw.FixedColumnWidth(15), 4: const pw.FixedColumnWidth(15), 5: const pw.FixedColumnWidth(20),
        6: const pw.FlexColumnWidth(1.5), 7: const pw.FixedColumnWidth(25), 8: const pw.FixedColumnWidth(25),
      },
      children: [
        pw.TableRow(decoration: const pw.BoxDecoration(color: PdfColors.grey200), children: [
          _tH("CANT"), _tH("UNID"), _tH("DESCRIPCIÓN"), _tH("B"), _tH("M"), _tH("N/A"), _tH("OBS."), _tH("ANT"), _tH("DES")
        ]),
        ...items.map((item) => pw.TableRow(children: [
          _tC(item['quantity']?.toString() ?? ""),
          _tC(item['measureUnit'] ?? ""),
          pw.Padding(padding: const pw.EdgeInsets.all(3), child: pw.Text(item['name'] ?? "", style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold))),
          _tC(item['status'] == 'GOOD' ? "V" : ""),
          _tC(item['status'] == 'BAD' ? "X" : ""),
          _tC(item['status'] == 'NOT_APPLICABLE' ? "N" : ""),
          pw.Padding(padding: const pw.EdgeInsets.all(3), child: pw.Text(item['observation'] ?? "", style: const pw.TextStyle(fontSize: 7))),
          _tC_Image(item['foto_antes_provider']),
          _tC_Image(item['foto_despues_provider']),
        ])),
      ],
    );
  }

  static pw.Widget _tH(String label) => pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(label, textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold)));
  static pw.Widget _tC(String val) => pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(val, textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 7)));
  static pw.Widget _tC_Image(pw.ImageProvider? provider) => pw.Container(height: 20, width: 20, alignment: pw.Alignment.center, padding: const pw.EdgeInsets.all(2), child: provider != null ? pw.Image(provider, fit: pw.BoxFit.cover) : pw.SizedBox());
  
  static pw.Widget _buildLoanFooterSection(Map<String, dynamic> data) {
    return pw.Column(children: [
      pw.SizedBox(height: 10),
      pw.Container(width: double.infinity, color: PdfColors.red900, padding: const pw.EdgeInsets.all(4), child: pw.Center(child: pw.Text("CAMPO DE PRÉSTAMO O DEVOLUCIÓN", style: pw.TextStyle(color: PdfColors.white, fontSize: 7, fontWeight: pw.FontWeight.bold)))),
      pw.Table(
        border: pw.TableBorder.all(width: 0.8),
        columnWidths: {0: const pw.FixedColumnWidth(150), 1: const pw.FlexColumnWidth()},
        children: [
          _footerRow("SOLICITA:", data['area_solicita'] ?? ""),
          _footerRow("RECIBE:", data['nombre_recibe'] ?? ""),
          _footerRow("OBSERVACIONES:", data['observaciones_footer'] ?? ""),
        ],
      ),
    ]);
  }

  static pw.TableRow _footerRow(String label, String val) => pw.TableRow(children: [
    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text(label, style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold))),
    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text(val, style: const pw.TextStyle(fontSize: 7))),
  ]);

  static pw.Widget _buildComponentEvidenciaGrande(dynamic item) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 15),
      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey400)),
      child: pw.Column(children: [
        pw.Container(width: double.infinity, padding: const pw.EdgeInsets.all(4), color: PdfColors.grey200, child: pw.Text("COMPONENTE: ${item['name']}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9))),
        pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceAround, children: [
          _fotoGrande("ANTES", item['foto_antes_provider']),
          _fotoGrande("DESPUÉS", item['foto_despues_provider']),
        ])),
      ]),
    );
  }

  static pw.Widget _fotoGrande(String label, pw.ImageProvider? provider) {
    return pw.Column(children: [
      pw.Text(label, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 4),
      pw.Container(width: 200, height: 140, decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey300)), child: provider != null ? pw.Image(provider, fit: pw.BoxFit.contain) : pw.SizedBox()),
    ]);
  }
}