import 'package:crv_reprosisa/features/evidence/domain/entities/upload_file_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageDatasource {
  final SupabaseClient client;

  SupabaseStorageDatasource(this.client);

  Future<String> uploadFile(UploadFileEntity file) async {
    final fullPath = '${file.path}/${file.fileName}';

    final localFile = File(file.localPath);

    await client.storage
        .from("evidences")
        .upload(
          fullPath,
          localFile,
          fileOptions: FileOptions(contentType: file.mimeType, upsert: false),
        );

    return fullPath;
  }
}
