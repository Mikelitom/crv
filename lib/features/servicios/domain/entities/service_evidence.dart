class ServiceEvidence {
  final String filePath;
  final String fileName;
  final String mimeType;
  final int sizeBytes;

  const ServiceEvidence({
    required this.filePath,
    required this.fileName,
    required this.mimeType,
    required this.sizeBytes,
  });

  Map<String, dynamic> toJson() {
    return {
      "file_path": filePath,
      "file_name": fileName,
      "mime_type": mimeType,
      "size_bytes": sizeBytes,
    };
  }
}