import 'dart:io';

import 'package:crv_reprosisa/features/ocr/presentation/providers/image_processor_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OCRDebugPage extends ConsumerWidget {
  const OCRDebugPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(imageProcessingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("OCR Debug"),
      ),
      body: Builder(
        builder: (_) {
          if (state.isProcessing) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.processedImage == null) {
            return const Center(
              child: Text(
                "No hay ninguna imagen procesada.",
              ),
            );
          }

          final image = state.processedImage!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                _ImageCard(
                  title: "Original",
                  imagePath: image.originalPath,
                ),

                if (image.grayPath != null)
                  _ImageCard(
                    title: "Escala de grises",
                    imagePath: image.grayPath!,
                  ),

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

                if (image.cannyPath != null)
                  _ImageCard(
                    title: "Canny",
                    imagePath: image.cannyPath!,
                  ),

                if (image.contourPath != null)
                  _ImageCard(
                    title: "Contornos",
                    imagePath: image.contourPath!,
                  ),

                if (image.perspectivePath != null)
                  _ImageCard(
                    title: "Perspectiva Corregida",
                    imagePath: image.perspectivePath!,
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

  const _ImageCard({
    required this.title,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 24),
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

            const SizedBox(height: 12),

            InteractiveViewer(
              minScale: 1,
              maxScale: 6,
              child: Image.file(
                File(imagePath),
              ),
            ),
          ],
        ),
      ),
    );
  }
}