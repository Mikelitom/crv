class EvidenceDto {
  final String filePath;
  final String fileType;
  final String mimeType;
  final String fileSize;

  EvidenceDto({
    required this.filePath,
    required this.fileType,
    required this.mimeType,
    required this.fileSize,
  });

  Map<String, dynamic> toJson() => {
    "file_path": filePath,
    "file_type": fileType,
    "mime_type": mimeType,
    "file_size": fileSize,
  };
}
