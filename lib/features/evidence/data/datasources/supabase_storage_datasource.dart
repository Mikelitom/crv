import 'package:crv_reprosisa/features/evidence/domain/entities/upload_file_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

class SupabaseStorageDatasource {
  final SupabaseClient client;

  SupabaseStorageDatasource(this.client);

  Future<String> uploadFile(UploadFileEntity file) async {
    final localFile = File(file.localPath);

    if (!await localFile.exists()) {
      throw Exception('El archivo no existe');
    }

    final uniqueName =
        '${DateTime.now().millisecondsSinceEpoch}_${file.fileName}';

    final fullPath = '${file.path}/$uniqueName';

    try {
      await client.storage
          .from("evidencias")
          .upload(
            fullPath,
            localFile,
            fileOptions: FileOptions(contentType: file.mimeType, upsert: false),
          );

      return fullPath;
    } on StorageException catch (e) {
      throw Exception('Error subiendo archivo: ${e.message}');
    }
  }
}
