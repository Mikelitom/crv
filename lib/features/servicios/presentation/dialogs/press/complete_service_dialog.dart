import 'dart:io';

import 'package:crv_reprosisa/features/evidence/presentation/providers/evidence_service_provider.dart';
import 'package:crv_reprosisa/features/evidence/presentation/service/evidence_service.dart';
import 'package:crv_reprosisa/features/servicios/data/models/press/press_service_order_model.dart';
import 'package:crv_reprosisa/features/servicios/presentation/mappers/evidence_dto_mapper.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/service_press_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class CompleteServiceDialog extends ConsumerStatefulWidget {
  final PressServiceOrderModel order;
  final String pressId;
  final Future<void> Function() onCompleted;

  const CompleteServiceDialog({
    super.key,
    required this.order,
    required this.pressId,
    required this.onCompleted,
  });

  @override
  ConsumerState<CompleteServiceDialog> createState() =>
      _CompleteServiceDialogState();
}

class _CompleteServiceDialogState extends ConsumerState<CompleteServiceDialog> {
  final List<File> _selectedFiles = [];
  bool _uploading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (image == null) return;

    setState(() {
      _selectedFiles.add(File(image.path));
    });
  }

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

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFFC62828)),
                title: const Text('Tomar foto con cámara', style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImageFromCamera();
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.folder_open, color: Color(0xFFC62828)),
                title: const Text('Subir archivos', style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickFiles();
                },
              ),
            ],
          ),
        );
      },
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
            "services/press/${widget.pressId}/service/${widget.order.id}",
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
              .read(completeServiceNotifierProvider.notifier)
              .completeService(widget.order.id, evidences);

          final state = ref.read(completeServiceNotifierProvider);

          if (!mounted) return;

          if (state.success) {
            await widget.onCompleted();

            Navigator.pop(context);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Servicio completado correctamente."),
              ),
            );

            ref.read(completeServiceNotifierProvider.notifier).reset();
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
        height: 180,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.folder_open, size: 48, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              "No hay evidencias seleccionadas",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 220,
      child: ListView.separated(
        itemCount: _selectedFiles.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, index) {
          final file = _selectedFiles[index];

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: ListTile(
              leading: _isImage(file)
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        file,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(_getFileIcon(file), size: 28, color: const Color(0xFFC62828)),
              title: Text(
                file.path.split('/').last,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: FutureBuilder<int>(
                future: file.length(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Text("Calculando...", style: TextStyle(fontSize: 10, color: Colors.grey));
                  }
                  return Text(_formatFileSize(snapshot.data!), style: const TextStyle(fontSize: 10, color: Colors.grey));
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
    const gb = mb * 1024;
    if (bytes >= gb) return "${(bytes / gb).toStringAsFixed(2)} GB";
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
      child: Container(
        width: 450,
        padding: const EdgeInsets.all(28),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Completar servicio",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              _buildEvidenceList(),
              const SizedBox(height: 20),
              Center(
                child: OutlinedButton.icon(
                  onPressed: _uploading ? null : () => _showImageSourceActionSheet(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFC62828),
                    side: const BorderSide(color: Color(0xFFC62828)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  icon: const Icon(Icons.attach_file, size: 18),
                  label: const Text(
                    "Agregar evidencias",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _uploading ? null : () => Navigator.pop(context),
                    child: const Text(
                      "Cancelar",
                      style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFC62828),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _uploading ? null : _completeService,
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
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}