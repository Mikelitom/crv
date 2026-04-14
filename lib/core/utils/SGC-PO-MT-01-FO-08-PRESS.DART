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

    final List<dynamic> itemsConEvidencia = (data['items'] as List<dynamic>)
        .where((item) => item['foto_antes_bytes'] != null || item['foto_despues_bytes'] != null)
        .toList();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter.landscape,
        margin: const pw.EdgeInsets.all(20),
        header: (context) => _buildSgcHeader(logoImage),
        build: (pw.Context context) {
          return [
            pw.SizedBox(height: 10),
            _buildGeneralInfoBox(data, pressImage),
            pw.SizedBox(height: 10),
            _buildInspectionTable(data['items'] ?? []),
            pw.SizedBox(height: 10),
            _buildFooterSection(data),
            if (itemsConEvidencia.isNotEmpty) ...[
              pw.NewPage(),
              pw.Center(child: pw.Text("ANEXO DE EVIDENCIAS FOTOGRÁFICAS", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.red900))),
              pw.SizedBox(height: 15),
              ...itemsConEvidencia.map((item) => _buildComponentEvidenciaGrande(item)),
            ]
          ];
        },
      ),
    );
    return pdf.save();
  }

  static pw.Widget _buildSgcHeader(pw.ImageProvider? logo) {
    return pw.Table(
      border: pw.TableBorder.all(width: 1),
      columnWidths: {0: const pw.FixedColumnWidth(130), 1: const pw.FlexColumnWidth(), 2: const pw.FixedColumnWidth(160)},
      children: [
        pw.TableRow(
          children: [
            pw.Container(height: 50, alignment: pw.Alignment.center, child: logo != null ? pw.Image(logo, width: 90) : pw.SizedBox()),
            pw.Column(children: [
              pw.Container(padding: const pw.EdgeInsets.all(2), child: pw.Text("RECUBRIMIENTOS, PRODUCTOS Y SERVICIOS INDUSTRIALES, S.A. DE C.V.", textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold))),
              pw.Divider(height: 1),
              pw.Container(padding: const pw.EdgeInsets.all(2), child: pw.Text("SISTEMA DE GESTIÓN DE CALIDAD", textAlign: pw.TextAlign.center, style: const pw.TextStyle(fontSize: 7))),
              pw.Divider(height: 1),
              pw.Container(padding: const pw.EdgeInsets.all(2), child: pw.Text("CHECK LIST DE PRENSAS", textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold))),
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

  static pw.Widget _hControlText(String text) => pw.Padding(padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2), child: pw.Text(text, style: const pw.TextStyle(fontSize: 6)));

  static pw.Widget _buildGeneralInfoBox(Map<String, dynamic> data, pw.ImageProvider? pressImg) {
    return pw.Container(
      decoration: pw.BoxDecoration(border: pw.Border.all(width: 1)),
      child: pw.Row(children: [
        pw.Expanded(
          flex: 3,
          child: pw.Padding(
            padding: const pw.EdgeInsets.all(8),
            child: pw.Column(children: [
              _infoLine("Fecha de inspección", data['fecha'] ?? "", area: data['area'] ?? ""),
              _infoLineSimple("Tipo", data['tipo'] ?? ""),
              _infoLineSimple("Modelo", data['modelo'] ?? ""),
              _infoLineSimple("VOLTS", data['volts'] ?? ""),
              _infoLineSimple("Serie", data['serie'] ?? "")
            ]),
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pressImg != null ? pw.Container(height: 80, padding: const pw.EdgeInsets.all(5), child: pw.Image(pressImg, fit: pw.BoxFit.contain)) : pw.SizedBox(),
        ),
      ]),
    );
  }

  static pw.Widget _infoLine(String label, String val, {String area = ""}) => pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 2),
    child: pw.Row(children: [
      pw.Text("$label: ", style: const pw.TextStyle(fontSize: 8)),
      pw.Expanded(child: pw.Container(decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 0.5))), child: pw.Text(val, style: const pw.TextStyle(fontSize: 8)))),
      pw.Text(" Área: ", style: const pw.TextStyle(fontSize: 8)),
      pw.Expanded(child: pw.Container(decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 0.5))), child: pw.Text(area, style: const pw.TextStyle(fontSize: 8))))
    ]),
  );

  static pw.Widget _infoLineSimple(String label, String val) => pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 2),
    child: pw.Row(children: [
      pw.SizedBox(width: 60, child: pw.Text("$label: ", style: const pw.TextStyle(fontSize: 8))),
      pw.Expanded(child: pw.Container(decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 0.5))), child: pw.Text(val, style: const pw.TextStyle(fontSize: 8))))
    ]),
  );

  static pw.Widget _buildInspectionTable(List<dynamic> items) {
    return pw.Table(
      border: pw.TableBorder.all(width: 0.8),
      columnWidths: {
        0: const pw.FixedColumnWidth(30), // CANT
        1: const pw.FixedColumnWidth(35), // UNIDAD
        2: const pw.FlexColumnWidth(2.5), // DESCRIPCIÓN (Más chico para dar espacio)
        3: const pw.FixedColumnWidth(20), // B
        4: const pw.FixedColumnWidth(20), // M
        5: const pw.FixedColumnWidth(25), // N/A
        6: const pw.FixedColumnWidth(110),// OBSERVACIONES
        7: const pw.FixedColumnWidth(40), // ANTES
        8: const pw.FixedColumnWidth(40), // DESPUÉS
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _tH("CANT"), _tH("UNID"),
            pw.Column(children: [
              pw.Text("Instrucción de llenado: (v) Buenas (X) Malas (N) No Aplica", style: const pw.TextStyle(fontSize: 4.5)),
              pw.Text("DESCRIPCIÓN", style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold))
            ]),
            _tH("B"), _tH("M"), _tH("N/A"), _tH("OBSERVACIONES"), _tH("ANT"), _tH("DES")
          ],
        ),
        ...items.map((item) {
          final String cantStr = (item['quantity'] == null || item['quantity'] == 0) ? "" : item['quantity'].toString();
          return pw.TableRow(children: [
            _tC(cantStr),
            _tC(item['measureUnit'] ?? ""),
            pw.Padding(padding: const pw.EdgeInsets.all(3), child: pw.Text(item['name'] ?? "", style: const pw.TextStyle(fontSize: 7))),
            _tC(item['status'] == 'good' ? "V" : ""),
            _tC(item['status'] == 'bad' ? "X" : ""),
            _tC(item['status'] == 'not_applicable' ? "N" : ""),
            pw.Padding(padding: const pw.EdgeInsets.all(3), child: pw.Text(item['observation'] ?? "", style: const pw.TextStyle(fontSize: 6.5))),
            _buildEvidenciaMini(item['foto_antes_bytes']),
            _buildEvidenciaMini(item['foto_despues_bytes']),
          ]);
        }).toList(),
      ],
    );
  }

  static pw.Widget _tH(String label) => pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(label, textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold)));
  static pw.Widget _tC(String val) => pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(val, textAlign: pw.TextAlign.center, style: const pw.TextStyle(fontSize: 7)));
  static pw.Widget _buildEvidenciaMini(Uint8List? bytes) => pw.Container(height: 18, width: 18, alignment: pw.Alignment.center, child: bytes != null ? pw.Image(pw.MemoryImage(bytes), fit: pw.BoxFit.contain) : pw.SizedBox());

  static pw.Widget _buildFooterSection(Map<String, dynamic> data) {
    return pw.Column(children: [
      pw.SizedBox(height: 10),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
        pw.Column(children: [
          pw.Container(width: 250, decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 1)))),
          pw.Text("NOMBRE Y FIRMA QUIEN REALIZA EL CHECKLIST", style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold))
        ])
      ]),
      pw.SizedBox(height: 10),
      pw.Container(width: double.infinity, color: PdfColors.red900, padding: const pw.EdgeInsets.all(3), child: pw.Center(child: pw.Text("En caso de préstamo o devolución de prensa (móvil) llenar este campo", style: pw.TextStyle(color: PdfColors.white, fontSize: 7, fontWeight: pw.FontWeight.bold)))),
      pw.Table(
        border: pw.TableBorder.all(width: 1),
        columnWidths: {0: const pw.FixedColumnWidth(200), 1: const pw.FlexColumnWidth()},
        children: [
          _footerRow("AREA O TALLER QUE SOLICITA:", data['area_solicita'] ?? ""),
          _footerRow("NOMBRE DE LA PERSONA QUE REALIZÓ EL CHECKLIST:", ""),
          _footerRow("OBSERVACIONES:", data['observaciones_footer'] ?? ""),
        ],
      ),
    ]);
  }

  static pw.TableRow _footerRow(String label, String val) => pw.TableRow(children: [
    pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(label, style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold))),
    pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(val, style: const pw.TextStyle(fontSize: 7))),
  ]);

  static pw.Widget _buildComponentEvidenciaGrande(dynamic item) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 15),
      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey400)),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(width: double.infinity, padding: const pw.EdgeInsets.all(4), color: PdfColors.grey200, child: pw.Text("COMPONENTE: ${item['name']}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9))),
          pw.Padding(
            padding: const pw.EdgeInsets.all(8),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                _fotoGrande("ANTES", item['foto_antes_bytes']),
                _fotoGrande("DESPUÉS", item['foto_despues_bytes']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _fotoGrande(String label, Uint8List? bytes) {
    return pw.Column(children: [
      pw.Text(label, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 4),
      pw.Container(
        width: 260, height: 170,
        decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey300)),
        child: bytes != null ? pw.Image(pw.MemoryImage(bytes), fit: pw.BoxFit.contain) : pw.Center(child: pw.Text("Sin evidencia", style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey400))),
      ),
    ]);
  }
}