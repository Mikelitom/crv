import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

class VehiculoPdfGenerator {
  static String generateFileName(Map<String, dynamic> data) {
    final String unidad = data['unidad'] ?? "SN";
    final String fecha = data['fecha'] ?? "SF";
    return "SGC-PO-MT-01-FO-03-$unidad-$fecha.pdf";
  }

  static Map<String, dynamic> mapStateToPdfData(dynamic state) {
    final String fechaActual = DateFormat('dd/MM/yyyy').format(state.inspectionDate);
    return {
      "unidad": state.selectedVehicle?.model ?? "S/N",
      "fecha": fechaActual,
      "placas": state.selectedVehicle?.plate ?? "---",
      "kilometraje": state.mileage,
      "requiere_servicio": state.requiresService,
      "notas": state.serviceObservations,
      "secciones": state.templateSections.map((sec) {
        return {
          "name": sec['name'],
          "items": (sec['components'] as List).map((c) {
            // Buscamos la respuesta correspondiente al componente
            final responses = state.items.where((i) => i.id == c['id']);
            final resp = responses.isNotEmpty ? responses.first : null;
            
            // Buscamos la opción seleccionada (BUENA, MALA, etc)
            final options = state.templateOptions.where((opt) => opt['id'] == resp?.selectedOptionId);
            final option = options.isNotEmpty ? options.first : {'code': ''};

            return {
              "name": c['name'],
              "status": option['code'].toString().toUpperCase(),
              "observation": resp?.observations ?? "",
              // Mapeo de fotos antes y después
              "foto_antes_bytes": resp?.evidences.where((e) => e.type == 'before' || e.type == 'antes').firstOrNull?.bytes,
              "foto_despues_bytes": resp?.evidences.where((e) => e.type == 'after' || e.type == 'despues').firstOrNull?.bytes,
            };
          }).toList(),
        };
      }).toList(),
    };
  }

  static Future<Uint8List> generateEsqueleto(Map<String, dynamic> data) async {
    final pdf = pw.Document();
    pw.ImageProvider? logoImage;
    try {
      logoImage = pw.MemoryImage((await rootBundle.load('assets/images/logo_reprosisa.png')).buffer.asUint8List());
    } catch (e) {
      print("Error logo: $e");
    }

    final List<dynamic> evidenciasAnexo = [];
    if (data['secciones'] != null) {
      for (var sec in data['secciones']) {
        for (var item in sec['items']) {
          if (item['foto_antes_bytes'] != null || item['foto_despues_bytes'] != null) {
            evidenciasAnexo.add(item);
          }
        }
      }
    }

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.letter,
      margin: const pw.EdgeInsets.all(20),
      header: (context) => _buildHeader(logoImage),
      build: (pw.Context context) => [
        pw.SizedBox(height: 10),
        _buildGeneralInfo(data),
        pw.SizedBox(height: 10),
        if (data['secciones'] != null)
          ...(data['secciones'] as List).map((sec) => _buildInspectionTable(sec['name'], sec['items'])),
        _buildServiceSection(data),
        pw.SizedBox(height: 20),
        _buildSignatureSection(),
        if (evidenciasAnexo.isNotEmpty) ...[
          pw.NewPage(),
          pw.Center(child: pw.Text("ANEXO DE EVIDENCIAS FOTOGRÁFICAS", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.red900))),
          pw.SizedBox(height: 20),
          ...evidenciasAnexo.map((ev) => _buildComponentEvidenciaGrande(ev)),
        ]
      ],
    ));
    return pdf.save();
  }

  static pw.Widget _buildHeader(pw.ImageProvider? logo) => pw.Table(
    border: pw.TableBorder.all(width: 1),
    columnWidths: {0: const pw.FixedColumnWidth(110), 1: const pw.FlexColumnWidth(), 2: const pw.FixedColumnWidth(150)},
    children: [pw.TableRow(children: [
      pw.Container(height: 50, alignment: pw.Alignment.center, child: logo != null ? pw.Image(logo, width: 85) : pw.SizedBox()),
      pw.Column(children: [
        pw.Text("RECUBRIMIENTOS, PRODUCTOS Y SERVICIOS INDUSTRIALES, S.A. DE C.V.", textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold)),
        pw.Divider(height: 1),
        pw.Text("Check List de Inspección de Unidades Móviles", textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
      ]),
      pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: pw.Text("CODIFICACIÓN: SGC-PO-MT-01-FO-03", style: const pw.TextStyle(fontSize: 6))),
        pw.Divider(height: 1),
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: pw.Text("FECHA DE EMISIÓN: 08/12/2022", style: const pw.TextStyle(fontSize: 6))),
      ]),
    ])],
  );

  static pw.Widget _buildGeneralInfo(Map<String, dynamic> data) => pw.Column(children: [
    pw.Row(children: [_infoLine("UNIDAD", data['unidad']), pw.SizedBox(width: 15), _infoLine("FECHA", data['fecha'])]),
    pw.SizedBox(height: 5),
    pw.Row(children: [_infoLine("PLACAS", data['placas']), pw.SizedBox(width: 15), _infoLine("KILOMETRAJE", data['kilometraje'])]),
  ]);

  static pw.Widget _infoLine(String label, String val) => pw.Expanded(child: pw.Row(children: [
    pw.Text("$label: ", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
    pw.Expanded(child: pw.Container(decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 0.5))), child: pw.Text(val ?? "", style: const pw.TextStyle(fontSize: 8)))),
  ]));

  static pw.Widget _buildInspectionTable(String title, List<dynamic> items) => pw.Table(
    border: pw.TableBorder.all(width: 0.5),
    columnWidths: {
      0: const pw.FlexColumnWidth(3),
      1: const pw.FixedColumnWidth(28),
      2: const pw.FixedColumnWidth(28),
      3: const pw.FixedColumnWidth(28),
      4: const pw.FixedColumnWidth(28),
      5: const pw.FixedColumnWidth(80),
      6: const pw.FixedColumnWidth(30),
      7: const pw.FixedColumnWidth(30),
    },
    children: [
      pw.TableRow(decoration: const pw.BoxDecoration(color: PdfColors.grey200), children: [
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: pw.Text(title, style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold))),
        _tH("BUENA"), _tH("MALA"), _tH("REPO."), _tH("REPA."), _tH("OBS."), _tH("ANT"), _tH("DES"),
      ]),
      ...items.map((item) => pw.TableRow(children: [
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: pw.Text(item['name'] ?? "", style: const pw.TextStyle(fontSize: 7))),
        _tC(item['status'] == 'GOOD' ? "V" : ""),
        _tC(item['status'] == 'BAD' ? "X" : ""),
        _tC(item['status'] == 'REPOSITION' ? "V" : ""),
        _tC(item['status'] == 'REPARATION' ? "V" : ""),
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: pw.Text(item['observation'] ?? "", style: const pw.TextStyle(fontSize: 6.5))),
        _buildEvidenciaMini(item['foto_antes_bytes']),
        _buildEvidenciaMini(item['foto_despues_bytes']),
      ])),
    ],
  );

  static pw.Widget _tH(String l) => pw.Center(child: pw.Text(l, style: pw.TextStyle(fontSize: 5, fontWeight: pw.FontWeight.bold)));
  static pw.Widget _tC(String v) => pw.Center(child: pw.Text(v, style: const pw.TextStyle(fontSize: 7.5)));

  static pw.Widget _buildEvidenciaMini(Uint8List? bytes) => pw.Container(
    height: 15, width: 15,
    alignment: pw.Alignment.center,
    child: bytes != null ? pw.Image(pw.MemoryImage(bytes), fit: pw.BoxFit.contain) : pw.SizedBox()
  );

  static pw.Widget _buildServiceSection(Map<String, dynamic> data) => pw.Column(children: [
    pw.Table(border: pw.TableBorder.all(width: 0.5), children: [pw.TableRow(children: [
      pw.Padding(padding: const pw.EdgeInsets.all(3), child: pw.Text("SERVICIO: REQUIERE SERVICIO", style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold))),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceAround, children: [
        pw.Text("SI: ${data['requiere_servicio'] == true ? 'V' : ''}", style: const pw.TextStyle(fontSize: 7)),
        pw.Text("NO: ${data['requiere_servicio'] == false ? 'V' : ''}", style: const pw.TextStyle(fontSize: 7)),
      ]),
      pw.Padding(padding: const pw.EdgeInsets.all(3), child: pw.Text("OBSERVACIONES", style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold))),
    ])]),
    pw.Container(width: double.infinity, padding: const pw.EdgeInsets.all(4), decoration: pw.BoxDecoration(border: pw.Border.all(width: 0.5)), child: pw.Text("NOTAS: ${data['notas'] ?? ''}", style: const pw.TextStyle(fontSize: 7))),
  ]);

  static pw.Widget _buildSignatureSection() => pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceAround, children: [
    _sigBox("RESPONSABLE DE LA UNIDAD"), _sigBox("REALIZÓ INSPECCIÓN"),
  ]);

  static pw.Widget _sigBox(String l) => pw.Column(children: [
    pw.Container(width: 180, decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 0.5)))),
    pw.Text(l, style: const pw.TextStyle(fontSize: 7)),
  ]);

  static pw.Widget _buildComponentEvidenciaGrande(dynamic item) => pw.Container(
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

  static pw.Widget _fotoGrande(String label, Uint8List? bytes) => pw.Column(children: [
    pw.Text(label, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
    pw.SizedBox(height: 4),
    pw.Container(
      width: 240, height: 150,
      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey300)),
      child: bytes != null ? pw.Image(pw.MemoryImage(bytes), fit: pw.BoxFit.contain) : pw.Center(child: pw.Text("Sin evidencia", style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey400))),
    ),
  ]);
}