import 'dart:io';

import 'package:crv_reprosisa/features/ocr/presentation/providers/image_processor_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ImageProcessingPreview extends ConsumerWidget {

  const ImageProcessingPreview({
    super.key,
  });


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final state = ref.watch(imageProcessingProvider);


    if (state.isProcessing) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: Color(0xFFC62828),
            ),
            SizedBox(height: 12),
            Text(
              "Procesando imagen...",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      );
    }


    if (state.processedImage == null) {
      return const Center(
        child: Text(
          "Captura una imagen para visualizar el procesamiento",
        ),
      );
    }


    final image = state.processedImage!;


    return SingleChildScrollView(
      child: Column(
        children: [

          const Text(
            "Resultado OpenCV",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),


          const SizedBox(height: 20),


          LayoutBuilder(
            builder: (context, constraints) {

              final isMobile = constraints.maxWidth < 700;


              return Flex(
                direction: isMobile
                    ? Axis.vertical
                    : Axis.horizontal,

                children: [

                  Expanded(
                    child: _ImageCard(
                      title: "Original",
                      path: image.originalPath,
                    ),
                  ),


                  SizedBox(
                    width: isMobile ? 0 : 20,
                    height: isMobile ? 20 : 0,
                  ),


                  Expanded(
                    child: _ImageCard(
                      title: "Procesada",
                      path: image.processedPath,
                    ),
                  ),

                ],
              );
            },
          ),

        ],
      ),
    );
  }
}



class _ImageCard extends StatelessWidget {

  final String title;
  final String path;


  const _ImageCard({
    required this.title,
    required this.path,
  });



  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 4,
      child: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),


          Padding(
            padding: const EdgeInsets.all(12),
            child: Image.file(
              File(path),
              fit: BoxFit.contain,
            ),
          ),

        ],
      ),
    );
  }
}