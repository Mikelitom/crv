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
            final responses = state.items.where((i) => i.id == c['id']);
            final resp = responses.isNotEmpty ? responses.first : null;
            
            final options = state.templateOptions.where((opt) => opt['id'] == resp?.selectedOptionId);
            final option = options.isNotEmpty ? options.first : {'code': ''};

            return {
              "name": c['name'],
              "status": option['code'].toString().toUpperCase(),
              "observation": resp?.observations ?? "",
              "foto_antes_bytes": (resp != null && resp.evidenceBefore != null && resp.evidenceBefore.isNotEmpty) 
                  ? resp.evidenceBefore.first.bytes 
                  : null,
              "foto_despues_bytes": (resp != null && resp.evidenceAfter != null && resp.evidenceAfter.isNotEmpty) 
                  ? resp.evidenceAfter.first.bytes 
                  : null,
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
      margin: const pw.EdgeInsets.all(25),
      header: (context) => _buildHeader(logoImage),
      build: (pw.Context context) => [
        pw.SizedBox(height: 15),
        _buildGeneralInfo(data),
        pw.SizedBox(height: 15),
        if (data['secciones'] != null)
          ...(data['secciones'] as List).map((sec) => _buildInspectionTable(sec['name'], sec['items'])),
        _buildServiceSection(data),
        if (evidenciasAnexo.isNotEmpty) ...[
          pw.NewPage(),
          pw.Center(
            child: pw.Text(
              "ANEXO DE EVIDENCIAS FOTOGRÁFICAS", 
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)
            )
          ),
          pw.SizedBox(height: 20),
          ...evidenciasAnexo.map((ev) => _buildComponentEvidenciaGrande(ev)),
        ]
      ],
    ));
    return pdf.save();
  }

  static pw.Widget _buildHeader(pw.ImageProvider? logo) => pw.Table(
    border: pw.TableBorder.all(width: 1.0),
    columnWidths: {0: const pw.FixedColumnWidth(110), 1: const pw.FlexColumnWidth(), 2: const pw.FixedColumnWidth(150)},
    children: [pw.TableRow(children: [
      pw.Container(height: 50, alignment: pw.Alignment.center, child: logo != null ? pw.Image(logo, width: 85) : pw.SizedBox()),
      pw.Column(children: [
        pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text("RECUBRIMIENTOS, PRODUCTOS Y SERVICIOS INDUSTRIALES, S.A. DE C.V.", textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold))),
        pw.Divider(height: 1),
        pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text("Check List de Inspección de Unidades Móviles", textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold))),
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
    pw.SizedBox(height: 8),
    pw.Row(children: [_infoLine("PLACAS", data['placas']), pw.SizedBox(width: 15), _infoLine("KILOMETRAJE", data['kilometraje'])]),
  ]);

  static pw.Widget _infoLine(String label, String val) => pw.Expanded(child: pw.Row(children: [
    pw.Text("$label: ", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
    pw.Expanded(child: pw.Container(decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 1.0))), child: pw.Text(val ?? "", style: const pw.TextStyle(fontSize: 8)))),
  ]));

  static pw.Widget _buildInspectionTable(String title, List<dynamic> items) => pw.Table(
    border: pw.TableBorder.all(width: 0.8),
    columnWidths: {
      0: const pw.FlexColumnWidth(3),
      1: const pw.FixedColumnWidth(30),
      2: const pw.FixedColumnWidth(30),
      3: const pw.FixedColumnWidth(30),
      4: const pw.FixedColumnWidth(30),
      5: const pw.FlexColumnWidth(2),
      6: const pw.FixedColumnWidth(35),
      7: const pw.FixedColumnWidth(35),
    },
    children: [
      pw.TableRow(decoration: const pw.BoxDecoration(color: PdfColors.grey200), children: [
        pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(title, style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold))),
        _tH("BUENA"), _tH("MALA"), _tH("REPO."), _tH("REPA."), _tH("OBS."), _tH("ANT"), _tH("DES"),
      ]),
      ...items.map((item) => pw.TableRow(children: [
        pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(item['name'] ?? "", style: const pw.TextStyle(fontSize: 7))),
        _tC(item['status'] == 'GOOD' ? "X" : ""),
        _tC(item['status'] == 'BAD' ? "X" : ""),
        _tC(item['status'] == 'REPOSITION' ? "X" : ""),
        _tC(item['status'] == 'REPARATION' ? "X" : ""),
        pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(item['observation'] ?? "", style: const pw.TextStyle(fontSize: 6.5))),
        _buildEvidenciaMini(item['foto_antes_bytes']),
        _buildEvidenciaMini(item['foto_despues_bytes']),
      ])),
    ],
  );

  static pw.Widget _tH(String l) => pw.Container(height: 18, alignment: pw.Alignment.center, child: pw.Text(l, style: pw.TextStyle(fontSize: 5, fontWeight: pw.FontWeight.bold)));
  static pw.Widget _tC(String v) => pw.Container(height: 18, alignment: pw.Alignment.center, child: pw.Text(v, style: const pw.TextStyle(fontSize: 7.5)));

  static pw.Widget _buildEvidenciaMini(Uint8List? bytes) => pw.Container(
    height: 18, width: 18,
    alignment: pw.Alignment.center,
    child: bytes != null ? pw.Image(pw.MemoryImage(bytes), fit: pw.BoxFit.contain) : pw.SizedBox()
  );

  static pw.Widget _buildServiceSection(Map<String, dynamic> data) => pw.Column(children: [
    pw.Table(
      border: pw.TableBorder.all(width: 1.0), 
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(1),
        2: const pw.FlexColumnWidth(2),
      },
      children: [
        pw.TableRow(children: [
          pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text("SERVICIO: REQUIERE SERVICIO", style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold))),
          pw.Container(
            height: 18, 
            alignment: pw.Alignment.center,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround, 
              children: [
                pw.Text("SI: ${data['requiere_servicio'] == true ? 'X' : ''}", style: const pw.TextStyle(fontSize: 7)),
                pw.Text("NO: ${data['requiere_servicio'] == false ? 'X' : ''}", style: const pw.TextStyle(fontSize: 7)),
              ]
            )
          ),
          // Aquí he corregido para que el texto de observaciones aparezca alineado al centro de la celda
          pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text("OBSERVACIONES", textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold))),
        ])
      ]
    ),
    // Este contenedor muestra el texto guardado en data['notas']
    pw.Container(
      width: double.infinity, 
      constraints: const pw.BoxConstraints(minHeight: 40), 
      padding: const pw.EdgeInsets.all(5), 
      decoration: pw.BoxDecoration(border: pw.Border.all(width: 1.0)), 
      child: pw.Text("${data['notas'] ?? ''}", style: const pw.TextStyle(fontSize: 7))
    ),
  ]);

  static pw.Widget _buildComponentEvidenciaGrande(dynamic item) => pw.Container(
    margin: const pw.EdgeInsets.only(bottom: 20),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text("COMPONENTE: ${item['name']}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
        pw.SizedBox(height: 8),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            _fotoGrande("ANTES", item['foto_antes_bytes']),
            _fotoGrande("DESPUÉS", item['foto_despues_bytes']),
          ],
        ),
        pw.Divider(color: PdfColors.grey300, thickness: 0.5),
      ],
    ),
  );

  static pw.Widget _fotoGrande(String label, Uint8List? bytes) => pw.Column(
    children: [
      pw.Text(label, style: const pw.TextStyle(fontSize: 8)),
      pw.SizedBox(height: 4),
      pw.Container(
        width: 250,
        height: 150,
        decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey400, width: 0.5)),
        child: bytes != null 
          ? pw.Image(pw.MemoryImage(bytes), fit: pw.BoxFit.contain) 
          : pw.Center(child: pw.Text("Sin evidencia", style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey400))),
      ),
    ]
  );
}