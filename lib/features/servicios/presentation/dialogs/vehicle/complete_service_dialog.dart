import 'dart:io';

import 'package:crv_reprosisa/features/evidence/presentation/providers/evidence_service_provider.dart';
import 'package:crv_reprosisa/features/evidence/presentation/service/evidence_service.dart';
import 'package:crv_reprosisa/features/servicios/data/models/v_service_order_model.dart';
import 'package:crv_reprosisa/features/servicios/presentation/mappers/evidence_dto_mapper.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/vehicle/service_providers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class CompleteServiceDialog extends ConsumerStatefulWidget {
  final ServiceOrderModel order;
  final String vehicleId;
  final Future<void> Function() onCompleted;

  const CompleteServiceDialog({
    super.key,
    required this.order,
    required this.vehicleId,
    required this.onCompleted,
  });

  @override
  ConsumerState<CompleteServiceDialog> createState() =>
      _CompleteServiceDialogState();
}

class _CompleteServiceDialogState extends ConsumerState<CompleteServiceDialog> {
  final List<File> _selectedFiles = [];
  bool _uploading = false;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: false,
    );

    if (result == null) return;

    final files = result.paths.whereType<String>().map(File.new).toList();

    setState(() {
      _selectedFiles.addAll(files);
    });
  }

  Future<void> _takePhoto() async {
    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (photo == null) return;

    setState(() {
      _selectedFiles.add(File(photo.path));
    });
  }

  void _showSourceSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Agregar evidencia",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFC62828).withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt, color: Color(0xFFC62828)),
              ),
              title: const Text("Tomar una foto", style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
            const Divider(height: 16),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFC62828).withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.folder_open, color: Color(0xFFC62828)),
              ),
              title: const Text("Seleccionar archivos", style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
                _pickFiles();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _completeService() async {
    if (_selectedFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Debe agregar al menos una evidencia.")),
      );
      return;
    }

    setState(() {
      _uploading = true;
    });

    try {
      final evidenceService = ref.read(evidenceServiceProvider);

      final uploadResult = await evidenceService.uploadMultiple(
        files: _selectedFiles,
        basePath:
            "services/vehicles/${widget.vehicleId}/service/${widget.order.id}",
      );

      await uploadResult.fold(
        (failure) async {
          if (!mounted) return;

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(failure.message)));
        },
        (uploadedEvidences) async {
          final evidences = uploadedEvidences
              .map((e) => e.toServiceEvidence())
              .toList();

          await ref
              .read(completeVehicleServiceNotifierProvider.notifier)
              .completeService(widget.order.id, evidences);

          final state = ref.read(completeVehicleServiceNotifierProvider);

          if (!mounted) return;

          if (state.success) {
            await widget.onCompleted();

            Navigator.pop(context);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Servicio completado correctamente."),
              ),
            );

            ref.read(completeVehicleServiceNotifierProvider.notifier).reset();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error ?? "Ocurrió un error.")),
            );
          }
        },
      );
    } finally {
      if (mounted) {
        setState(() {
          _uploading = false;
        });
      }
    }
  }

  Widget _buildEvidenceList() {
    if (_selectedFiles.isEmpty) {
      return Container(
        height: 160,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.folder_open, size: 42, color: Colors.grey),
            SizedBox(height: 10),
            Text(
              "No hay evidencias seleccionadas",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: ListView.separated(
        itemCount: _selectedFiles.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, index) {
          final file = _selectedFiles[index];

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: ListTile(
              leading: _isImage(file)
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        file,
                        width: 42,
                        height: 42,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(_getFileIcon(file), size: 28, color: const Color(0xFFC62828)),
              title: Text(
                file.path.split('/').last,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              subtitle: FutureBuilder<int>(
                future: file.length(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Text("Calculando...", style: TextStyle(fontSize: 11));
                  }
                  return Text(_formatFileSize(snapshot.data!), style: const TextStyle(fontSize: 11));
                },
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                onPressed: _uploading
                    ? null
                    : () {
                        setState(() {
                          _selectedFiles.removeAt(index);
                        });
                      },
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getFileIcon(File file) {
    final extension = file.path.split('.').last.toLowerCase();
    switch (extension) {
      case "png":
      case "jpg":
      case "jpeg":
      case "gif":
      case "bmp":
      case "webp":
        return Icons.image;
      case "pdf":
        return Icons.picture_as_pdf;
      case "mp4":
      case "mov":
      case "avi":
      case "mkv":
        return Icons.video_file;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _formatFileSize(int bytes) {
    const kb = 1024;
    const mb = kb * 1024;
    if (bytes >= mb) return "${(bytes / mb).toStringAsFixed(2)} MB";
    if (bytes >= kb) return "${(bytes / kb).toStringAsFixed(2)} KB";
    return "$bytes B";
  }

  bool _isImage(File file) {
    final extension = file.path.split('.').last.toLowerCase();
    return ["png", "jpg", "jpeg", "gif", "bmp", "webp"].contains(extension);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 10,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        constraints: const BoxConstraints(maxWidth: 450, maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Completar servicio",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Flexible(child: SingleChildScrollView(child: _buildEvidenceList())),
            const SizedBox(height: 16),
            Center(
              child: OutlinedButton.icon(
                onPressed: _uploading ? null : () => _showSourceSelector(context),
                icon: const Icon(Icons.attach_file, color: Color(0xFFC62828), size: 18),
                label: const Text(
                  "Agregar evidencias o tomar foto",
                  style: TextStyle(
                    color: Color(0xFFC62828),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFC62828)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: _uploading ? null : () => Navigator.pop(context),
                    child: const Text(
                      "Cancelar",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _uploading ? null : _completeService,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC62828),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: _uploading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Completar",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}