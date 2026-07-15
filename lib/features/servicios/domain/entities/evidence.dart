class Evidence {
  final String id;
  final String filePath;
  final String fileName;
  final String mimeType;
  final int sizeBytes;
  final DateTime createdAt;
  final String? signedUrl;

  Evidence({
    required this.id,
    required this.filePath,
    required this.fileName,
    required this.mimeType,
    required this.sizeBytes,
    required this.createdAt,
    this.signedUrl,
  });

  factory Evidence.fromJson(Map<String, dynamic> json) {
    return Evidence(
      id: json['id'],
      filePath: json['file_path'],
      fileName: json['file_name'],
      mimeType: json['mime_type'],
      sizeBytes: json['size_bytes'],
      createdAt: DateTime.parse(json['created_at']),
      signedUrl: json['signed_url'],
    );
  }
}