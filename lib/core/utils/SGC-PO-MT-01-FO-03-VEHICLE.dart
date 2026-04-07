import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class VehiculoPdfGenerator {
  static String generateFileName(Map<String, dynamic> data) {
    final String unidad = data['unidad'] ?? "SIN_UNIDAD";
    final String fecha = data['fecha'] ?? "SIN_FECHA";
    return "SGC-PO-MT-01-FO-03-$unidad-$fecha.pdf";
  }

  static Future<Uint8List> generateEsqueleto(Map<String, dynamic> data) async {
    final pdf = pw.Document();
    pw.ImageProvider? logoImage;

    try {
      logoImage = pw.MemoryImage((await rootBundle.load('assets/images/logo_reprosisa.png')).buffer.asUint8List());
    } catch (e) {
      print("Error cargando logo: $e");
    }

    pdf.addPage(
      pw.MultiPage( // MultiPage para permitir que las tablas fluyan si son largas
        pageFormat: PdfPageFormat.letter,
        margin: const pw.EdgeInsets.all(20),
        header: (context) => _buildHeader(logoImage),
        build: (pw.Context context) {
          return [
            pw.SizedBox(height: 10),
            _buildGeneralInfo(data),
            pw.SizedBox(height: 10),
            _buildSectionTitle("MOTOR"),
            _buildInspectionTable(data['motor_items'] ?? []),
            pw.SizedBox(height: 10),
            _buildSectionTitle("CHASIS"),
            _buildInspectionTable(data['chasis_items'] ?? []),
            pw.SizedBox(height: 10),
            _buildSectionTitle("INTERIOR"),
            _buildInspectionTable(data['interior_items'] ?? []),
            pw.SizedBox(height: 10),
            _buildServiceSection(data),
            pw.SizedBox(height: 20),
            _buildSignatureSection(data),
          ];
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeader(pw.ImageProvider? logo) {
    return pw.Table(
      border: pw.TableBorder.all(width: 1),
      columnWidths: {
        0: const pw.FixedColumnWidth(130),
        1: const pw.FlexColumnWidth(),
        2: const pw.FixedColumnWidth(160),
      },
      children: [
        pw.TableRow(
          children: [
            pw.Container(
              height: 55,
              alignment: pw.Alignment.center,
              child: logo != null ? pw.Image(logo, width: 95, fit: pw.BoxFit.contain) : pw.SizedBox(),
            ),
            pw.Column(
              children: [
                pw.Container(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text("RECUBRIMIENTOS, PRODUCTOS Y SERVICIOS INDUSTRIALES, S.A. DE C.V.",
                    textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold)),
                ),
                pw.Divider(height: 1),
                pw.Container(
                  padding: const pw.EdgeInsets.all(3),
                  child: pw.Text("Sistema de Gestión de Calidad", textAlign: pw.TextAlign.center, style: const pw.TextStyle(fontSize: 7)),
                ),
                pw.Divider(height: 1),
                pw.Container(
                  padding: const pw.EdgeInsets.all(3),
                  child: pw.Text("Check List de Inspección de Unidades Móviles", textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                ),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _hText("PÁGINA: Página 1 de 1"),
                pw.Divider(height: 1),
                _hText("CODIFICACIÓN: SGC-PO-MT-01-FO-03"),
                pw.Divider(height: 1),
                _hText("NÚMERO DE REVISIÓN: 04"),
                pw.Divider(height: 1),
                _hText("FECHA DE EMISIÓN: 08/12/2022"),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _hText(String text) => pw.Padding(padding: const pw.EdgeInsets.all(3), child: pw.Text(text, style: const pw.TextStyle(fontSize: 6)));

  static pw.Widget _buildGeneralInfo(Map<String, dynamic> data) {
    return pw.Column(
      children: [
        pw.Row(children: [
          _infoLine("UNIDAD", data['unidad'] ?? ""),
          pw.SizedBox(width: 10),
          _infoLine("FECHA", data['fecha'] ?? ""),
        ]),
        pw.SizedBox(height: 5),
        pw.Row(children: [
          _infoLine("PLACAS", data['placas'] ?? ""),
          pw.SizedBox(width: 10),
          _infoLine("KILOMETRAJE", data['kilometraje'] ?? ""),
        ]),
      ],
    );
  }

  static pw.Widget _infoLine(String label, String val) {
    return pw.Expanded(
      child: pw.Row(children: [
        pw.Text("$label: ", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
        pw.Expanded(child: pw.Container(decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 0.5))), child: pw.Text(val, style: const pw.TextStyle(fontSize: 8)))),
      ]),
    );
  }

  static pw.Widget _buildSectionTitle(String title) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(2),
      decoration: const pw.BoxDecoration(color: PdfColors.grey300),
      child: pw.Text(title, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
    );
  }

  static pw.Widget _buildInspectionTable(List<dynamic> items) {
    return pw.Table(
      border: pw.TableBorder.all(width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(2), // DESCRIPCIÓN
        1: const pw.FixedColumnWidth(30), // B
        2: const pw.FixedColumnWidth(30), // M
        3: const pw.FixedColumnWidth(40), // REPOSICIÓN
        4: const pw.FixedColumnWidth(40), // REPARACIÓN
        5: const pw.FixedColumnWidth(100), // OBSERVACIONES
      },
      children: [
        pw.TableRow(
          children: [
            _tH("DESCRIPCIÓN"), _tH("B"), _tH("M"), _tH("REP."), _tH("REPAR."), _tH("OBSERVACIONES"),
          ],
        ),
        ...items.map((item) => pw.TableRow(
          children: [
            pw.Padding(padding: const pw.EdgeInsets.all(3), child: pw.Text(item['name'] ?? "", style: const pw.TextStyle(fontSize: 7))),
            _tC(item['estado'] == 0 ? "V" : ""),
            _tC(item['estado'] == 1 ? "X" : ""),
            _tC(item['estado'] == 2 ? "V" : ""),
            _tC(item['estado'] == 3 ? "V" : ""),
            pw.Padding(padding: const pw.EdgeInsets.all(3), child: pw.Text(item['observaciones'] ?? "", style: const pw.TextStyle(fontSize: 6))),
          ],
        )),
      ],
    );
  }

  static pw.Widget _tH(String label) => pw.Center(child: pw.Padding(padding: const pw.EdgeInsets.all(3), child: pw.Text(label, style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold))));
  static pw.Widget _tC(String val) => pw.Center(child: pw.Text(val, style: const pw.TextStyle(fontSize: 7.5)));

  static pw.Widget _buildServiceSection(Map<String, dynamic> data) {
    return pw.Table(
      border: pw.TableBorder.all(width: 0.5),
      children: [
        pw.TableRow(children: [
          pw.Padding(padding: const pw.EdgeInsets.all(3), child: pw.Text("REQUIERE SERVICIO:", style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold))),
          pw.Center(child: pw.Text(data['requiere_servicio'] == true ? "SI" : "NO", style: const pw.TextStyle(fontSize: 7))),
          pw.Expanded(child: pw.Padding(padding: const pw.EdgeInsets.all(3), child: pw.Text("NOTAS: ${data['notas'] ?? ''}", style: const pw.TextStyle(fontSize: 7)))),
        ])
      ],
    );
  }

  static pw.Widget _buildSignatureSection(Map<String, dynamic> data) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
      children: [
        _signatureBox("RESPONSABLE DE LA UNIDAD", data['responsable_nombre'] ?? ""),
        _signatureBox("REALIZO INSPECCION", data['usuario_nombre'] ?? ""),
      ],
    );
  }

  static pw.Widget _signatureBox(String label, String name) {
    return pw.Column(
      children: [
        pw.Text(name, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
        pw.Container(width: 150, decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 0.5)))),
        pw.Text(label, style: const pw.TextStyle(fontSize: 7)),
        pw.Text("NOMBRE Y FIRMA", style: const pw.TextStyle(fontSize: 6)),
      ],
    );
  }
}