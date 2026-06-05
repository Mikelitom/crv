// lib/core/utils/image_downloader.dart
import 'dart:typed_data';
import 'package:dio/dio.dart';

class ImageDownloader {
  // Ahora requiere la instancia de Dio autenticada
  static Future<Uint8List?> download(Dio dio, String url) async {
    try {
      final response = await dio.get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      if (response.statusCode == 200) {
        return Uint8List.fromList(response.data);
      }
    } catch (e) {
      print("Error bajando imagen con Dio autenticado: $e");
    }
    return null;
  }
}