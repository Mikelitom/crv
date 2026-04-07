class UploadFileEntity {
  final String path;
  final String fileName;
  final String mimeType;

  final String localPath;

  UploadFileEntity({
    required this.path,
    required this.fileName,
    required this.mimeType,
    required this.localPath,
  });
}
