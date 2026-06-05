// lib/features/assets/presentation/pages/pdf_viewer_page.dart
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../../../../core/utils/SGC-PO-MT-01-FO-08-PRESS.dart';
class PdfViewerPage extends StatelessWidget {
  final Map<String, dynamic> datos;

  const PdfViewerPage({super.key, required this.datos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vista Previa PDF")),
      body: PdfPreview(
        build: (format) => PrensaPdfGenerator.generateEsqueleto(datos),
      ),
    );
  }
}