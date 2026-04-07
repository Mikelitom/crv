import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PrensaPdfGenerator {
  // ESTE ES EL MÉTODO QUE TE FALTABA
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
      logoImage = pw.MemoryImage(
          (await rootBundle.load('assets/images/logo_reprosisa.png'))
              .buffer
              .asUint8List());
      pressImage = pw.MemoryImage(
          (await rootBundle.load('assets/images/press.jpg'))
              .buffer
              .asUint8List());
    } catch (e) {
      // Manejo de error si las imágenes no existen
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.letter,
        margin: const pw.EdgeInsets.all(25),
        build: (pw.Context context) {
          return pw.Column(
            children: [
              _buildSgcHeader(logoImage),
              pw.SizedBox(height: 10),
              _buildGeneralInfoBox(data, pressImage),
              pw.SizedBox(height: 15),
              _buildInspectionTable(data['items'] ?? []),
              pw.SizedBox(height: 10),
              _buildFooterSection(data),
            ],
          );
        },
      ),
    );
    return pdf.save();
  }

  static pw.Widget _buildSgcHeader(pw.ImageProvider? logo) {
    return pw.Table(
      border: pw.TableBorder.all(width: 1),
      columnWidths: {
        0: const pw.FixedColumnWidth(130),
        1: const pw.FlexColumnWidth(),
        2: const pw.FixedColumnWidth(160)
      },
      children: [
        pw.TableRow(
          children: [
            pw.Container(
                height: 55,
                alignment: pw.Alignment.center,
                child: logo != null
                    ? pw.Image(logo, width: 100, fit: pw.BoxFit.contain)
                    : pw.SizedBox()),
            pw.Column(children: [
              pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text(
                      "RECUBRIMIENTOS, PRODUCTOS Y SERVICIOS INDUSTRIALES, S.A. DE C.V.",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          fontSize: 7, fontWeight: pw.FontWeight.bold))),
              pw.Divider(height: 1),
              pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(3),
                  child: pw.Text("SISTEMA DE GESTIÓN DE CALIDAD",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 7))),
              pw.Divider(height: 1),
              pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(3),
                  child: pw.Text("CHECK LIST DE PRENSAS",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          fontSize: 8, fontWeight: pw.FontWeight.bold))),
            ]),
            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              _hControlText("Código: SGC-PO-MT-01-FO-08"),
              pw.Divider(height: 1),
              _hControlText("Fecha de emisión: 15/09/2022"),
              pw.Divider(height: 1),
              _hControlText("Revisión: 01"),
              pw.Divider(height: 1),
              _hControlText("Página 1 de 1"),
            ]),
          ],
        ),
      ],
    );
  }

  static pw.Widget _hControlText(String text) => pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      child: pw.Text(text, style: const pw.TextStyle(fontSize: 6.5)));

  static pw.Widget _buildGeneralInfoBox(Map<String, dynamic> data, pw.ImageProvider? pressImg) {
    return pw.Container(
      decoration: pw.BoxDecoration(border: pw.Border.all(width: 1.2)),
      child: pw.Column(children: [
        pw.Container(
            width: double.infinity,
            decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 1))),
            padding: const pw.EdgeInsets.all(2),
            child: pw.Center(child: pw.Text("CHECK LIST DE PRENSAS", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)))),
        pw.Padding(
            padding: const pw.EdgeInsets.all(8),
            child: pw.Row(children: [
              pw.Expanded(
                  flex: 3,
                  child: pw.Column(children: [
                    _infoLine("Fecha de inspeccion", data['fecha'] ?? "", area: data['area'] ?? ""),
                    _infoLineSimple("Tipo", data['tipo'] ?? ""),
                    _infoLineSimple("Modelo", data['modelo'] ?? ""),
                    _infoLineSimple("VOLTS", data['volts'] ?? ""),
                    _infoLineSimple("Serie", data['serie'] ?? "")
                  ])),
              pw.Expanded(flex: 1, child: pressImg != null ? pw.Container(height: 80, child: pw.Image(pressImg, fit: pw.BoxFit.contain)) : pw.SizedBox()),
            ])),
      ]),
    );
  }

  static pw.Widget _infoLine(String label, String val, {String area = ""}) => pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2.5),
      child: pw.Row(children: [
        pw.Text("$label: ", style: const pw.TextStyle(fontSize: 8)),
        pw.Expanded(child: pw.Container(decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 0.5))), child: pw.Text(val, style: const pw.TextStyle(fontSize: 8)))),
        pw.Text(" Area: ", style: const pw.TextStyle(fontSize: 8)),
        pw.Expanded(child: pw.Container(decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 0.5))), child: pw.Text(area, style: const pw.TextStyle(fontSize: 8))))
      ]));

  static pw.Widget _infoLineSimple(String label, String val) => pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2.5),
      child: pw.Row(children: [
        pw.SizedBox(width: 50, child: pw.Text("$label: ", style: const pw.TextStyle(fontSize: 8))),
        pw.Expanded(child: pw.Container(decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 0.5))), child: pw.Text(val, style: const pw.TextStyle(fontSize: 8))))
      ]));

  static pw.Widget _buildInspectionTable(List<dynamic> items) {
    return pw.Table(
      border: pw.TableBorder.all(width: 0.8),
      columnWidths: {
        0: const pw.FixedColumnWidth(35),
        1: const pw.FixedColumnWidth(45),
        2: const pw.FlexColumnWidth(),
        3: const pw.FixedColumnWidth(30),
        4: const pw.FixedColumnWidth(30),
        5: const pw.FixedColumnWidth(30),
        6: const pw.FixedColumnWidth(130),
        7: const pw.FixedColumnWidth(70)
      },
      children: [
        pw.TableRow(decoration: const pw.BoxDecoration(color: PdfColors.grey200), children: [
          _tH("CANT"), _tH("UNIDAD"),
          pw.Column(children: [
            pw.Text("Instrucción: (V) Buenas (X) Malas (N) No Aplica", style: const pw.TextStyle(fontSize: 4.5)),
            pw.Text("DESCRIPCIÓN", style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold))
          ]),
          _tH("B"), _tH("M"), _tH("N/A"), _tH("OBSERVACIONES"), _tH("EVIDENCIA")
        ]),
        ...items.map((item) {
          final val = item['cant'];
          final String cantStr = (val == null || val == 0 || val == 1 || val == '1') ? "" : val.toString();
          return pw.TableRow(children: [
            _tC(cantStr),
            _tC(item['unidad'] ?? ""),
            pw.Padding(padding: const pw.EdgeInsets.all(3), child: pw.Text(item['descripcion'] ?? "", style: const pw.TextStyle(fontSize: 7))),
            _tC(item['estado'] == 0 ? "V" : ""),
            _tC(item['estado'] == 1 ? "X" : ""),
            _tC(item['estado'] == 2 ? "N" : ""),
            pw.Padding(padding: const pw.EdgeInsets.all(3), child: pw.Text(item['observaciones'] ?? "", style: const pw.TextStyle(fontSize: 6.5))),
            _buildEvidenciaCell(item['foto_bytes'])
          ]);
        }).toList(),
      ],
    );
  }

  static pw.Widget _tH(String label) => pw.Center(child: pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(label, style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold))));
  static pw.Widget _tC(String val) => pw.Center(child: pw.Padding(padding: const pw.EdgeInsets.symmetric(vertical: 4), child: pw.Text(val, style: const pw.TextStyle(fontSize: 7.5))));

  static pw.Widget _buildEvidenciaCell(Uint8List? bytes) {
    if (bytes == null) return pw.SizedBox();
    return pw.Container(height: 25, width: 25, padding: const pw.EdgeInsets.all(2), child: pw.Image(pw.MemoryImage(bytes), fit: pw.BoxFit.contain));
  }

  static pw.Widget _buildFooterSection(Map<String, dynamic> data) {
    return pw.Column(children: [
      pw.SizedBox(height: 15),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
        pw.Column(children: [
          pw.Container(width: 250, decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 1)))),
          pw.Text("NOMBRE DE QUIEN REALIZA EL CHECKLIST", style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold))
        ])
      ]),
      pw.SizedBox(height: 10),
      pw.Container(width: double.infinity, color: PdfColors.red900, padding: const pw.EdgeInsets.all(3), child: pw.Center(child: pw.Text("En caso de préstamo o devolución de prensa (móvil) llenar este campo", style: pw.TextStyle(color: PdfColors.white, fontSize: 7, fontWeight: pw.FontWeight.bold)))),
      pw.Table(border: pw.TableBorder.all(width: 1), columnWidths: {0: const pw.FixedColumnWidth(150), 1: const pw.FlexColumnWidth()}, children: [
        pw.TableRow(children: [
          pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text("AREA O TALLER QUE SOLICITA:", style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold))),
          pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(data['area_solicita'] ?? "", style: const pw.TextStyle(fontSize: 7)))
        ]),
        pw.TableRow(children: [
          pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text("NOMBRE DE QUIEN RECIBE LA PRENSA :", style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold))),
          pw.SizedBox(height: 25)
        ]),
        pw.TableRow(children: [
          pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text("OBSERVACIONES:", style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold))),
          pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(data['observaciones_footer'] ?? "", style: const pw.TextStyle(fontSize: 7)))
        ]),
      ]),
    ]);
  }
}