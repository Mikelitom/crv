import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class ClientPdfViewerPage extends StatelessWidget {
  // Ahora el generador es específico para el reporte de bandas
  final Future<Uint8List> Function() pdfGenerator;
  final String folio;

  const ClientPdfViewerPage({
    super.key, 
    required this.pdfGenerator, 
    required this.folio,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reporte Folio: $folio"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: PdfPreview(
        build: (format) => pdfGenerator(),
        canChangePageFormat: false,
        canChangeOrientation: true,
        useActions: true,
      ),
    );
  }
}