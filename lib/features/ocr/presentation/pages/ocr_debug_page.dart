import 'dart:io';

import 'package:crv_reprosisa/features/ocr/domain/entities/processed_image.dart';
import 'package:crv_reprosisa/features/ocr/presentation/providers/image_processor_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OCRDebugPage extends ConsumerWidget {
  const OCRDebugPage({super.key});

  Future<void> _reprocess(WidgetRef ref, ProcessedImage image) async {
    // Todas las imágenes que OpenCV puede sobrescribir.
    final paths = <String?>[
      image.grayPath,
      image.clahePath,
      image.blurPath,
      image.thresholdPath,
      image.medianPath,
      image.dilatedPath,
      image.closedPath,
      image.contourPath,
      image.perspectivePath,
      image.layoutPath,
      image.pressRowsPath,
      image.pressCheckboxesPath,
      image.pressCheckboxRoisPath,
      image.vehicleTablesPath,
      image.vehicleRowsPath,
      image.vehicleCheckboxesPath,
    ];

    // Sacamos las imágenes actuales del cache de Flutter
    // ANTES de volver a procesarlas.
    for (final path in paths) {
      await FileImage(File(path!)).evict();
    }

    await ref.read(imageProcessingProvider.notifier).reprocess();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(imageProcessingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("OCR Debug"),
        actions: [
          IconButton(
            tooltip: "Reprocesar imagen",
            onPressed: state.processedImage == null || state.isProcessing
                ? null
                : () {
                    _reprocess(ref, state.processedImage!);
                  },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Builder(
        builder: (_) {
          if (state.isProcessing) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  state.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          if (state.processedImage == null) {
            return const Center(
              child: Text("No hay ninguna imagen procesada."),
            );
          }

          final image = state.processedImage!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _ImageCard(title: "Original", imagePath: image.originalPath),

                if (image.grayPath != null)
                  _ImageCard(
                    title: "Escala de grises",
                    imagePath: image.grayPath!,
                  ),

                if (image.clahePath != null)
                  _ImageCard(title: "CLAHE", imagePath: image.clahePath!),

                if (image.blurPath != null)
                  _ImageCard(
                    title: "Gaussian Blur",
                    imagePath: image.blurPath!,
                  ),

                if (image.thresholdPath != null)
                  _ImageCard(
                    title: "Adaptive Threshold",
                    imagePath: image.thresholdPath!,
                  ),

                if (image.medianPath != null)
                  _ImageCard(
                    title: "Median Blur",
                    imagePath: image.medianPath!,
                  ),

                if (image.dilatedPath != null)
                  _ImageCard(title: "Dilated", imagePath: image.dilatedPath!),

                if (image.closedPath != null)
                  _ImageCard(
                    title: "Morph Close",
                    imagePath: image.closedPath!,
                  ),

                if (image.contourPath != null)
                  _ImageCard(title: "Contornos", imagePath: image.contourPath!),

                if (image.perspectivePath != null)
                  _ImageCard(
                    title: "Perspectiva",
                    imagePath: image.perspectivePath!,
                  ),

                if (image.layoutPath != null)
                  _ImageCard(title: "Layout", imagePath: image.layoutPath!),

                if (image.pressRowsPath != null)
                  _ImageCard(
                    title: "Filas de inspección - Prensa",
                    imagePath: image.pressRowsPath!,
                  ),

                if (image.pressCheckboxesPath != null)
                  _ImageCard(
                    title: "Casillas - Prensa",
                    imagePath: image.pressCheckboxesPath!,
                  ),

                if (image.pressCheckboxRoisPath != null)
                  _ImageCard(
                    title: "ROI de checkboxes - Prensa",
                    imagePath: image.pressCheckboxRoisPath!,
                  ),

                if (image.vehicleTablesPath != null)
                  _ImageCard(
                    title: "Tablas de inspección - Vehículo",
                    imagePath: image.vehicleTablesPath!,
                  ),

                if (image.vehicleRowsPath != null)
                  _ImageCard(
                    title: "Filas de inspección - Vehículo",
                    imagePath: image.vehicleRowsPath!,
                  ),

                if (image.vehicleCheckboxesPath != null)
                  _ImageCard(
                    title: "Casillas - Vehículo",
                    imagePath: image.vehicleCheckboxesPath!,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ImageCard extends StatelessWidget {
  final String title;
  final String imagePath;

  const _ImageCard({required this.title, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final file = File(imagePath);

    final exists = file.existsSync();

    return SizedBox(
      width: 350,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              SelectableText(
                imagePath,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),

              const SizedBox(height: 8),

              Text(
                exists
                    ? "Tamaño: ${(file.lengthSync() / 1024).toStringAsFixed(1)} KB"
                    : "Archivo no encontrado",
                style: const TextStyle(fontSize: 12),
              ),

              const SizedBox(height: 12),

              if (!exists)
                const SizedBox(
                  height: 250,
                  child: Center(
                    child: Text(
                      "No se encontró la imagen",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                )
              else
                InteractiveViewer(
                  minScale: 1,
                  maxScale: 8,
                  child: Image.file(
                    file,
                    errorBuilder: (_, error, __) {
                      return SizedBox(
                        height: 250,
                        child: Center(
                          child: Text(
                            error.toString(),
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
