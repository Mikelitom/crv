import 'dart:io';

import 'package:crv_reprosisa/features/evidence/presentation/providers/evidence_service_provider.dart';
import 'package:crv_reprosisa/features/evidence/presentation/service/evidence_service.dart';
import 'package:crv_reprosisa/features/servicios/data/models/v_service_order_model.dart';
import 'package:crv_reprosisa/features/servicios/presentation/mappers/evidence_dto_mapper.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/vehicle/service_providers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        height: 180,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.folder_open, size: 48, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              "No hay evidencias seleccionadas",
              style: TextStyle(color: Colors.grey, fontSize: 15),
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

          return Card(
            elevation: 1,
            child: ListTile(
              leading: _isImage(file)
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        file,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(_getFileIcon(file), size: 30),

              title: Text(
                file.path.split('/').last,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              subtitle: FutureBuilder<int>(
                future: file.length(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Text("Calculando tamaño...");
                  }

                  return Text(_formatFileSize(snapshot.data!));
                },
              ),

              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
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

      case "doc":
      case "docx":
        return Icons.description;

      case "xls":
      case "xlsx":
        return Icons.table_chart;

      default:
        return Icons.insert_drive_file;
    }
  }

  String _formatFileSize(int bytes) {
    const kb = 1024;
    const mb = kb * 1024;
    const gb = mb * 1024;

    if (bytes >= gb) {
      return "${(bytes / gb).toStringAsFixed(2)} GB";
    }

    if (bytes >= mb) {
      return "${(bytes / mb).toStringAsFixed(2)} MB";
    }

    if (bytes >= kb) {
      return "${(bytes / kb).toStringAsFixed(2)} KB";
    }

    return "$bytes B";
  }

  bool _isImage(File file) {
    final extension = file.path.split('.').last.toLowerCase();

    return ["png", "jpg", "jpeg", "gif", "bmp", "webp"].contains(extension);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Completar servicio"),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEvidenceList(),
  
              const SizedBox(height: 16),
  
              ElevatedButton.icon(
                onPressed: _uploading ? null : _pickFiles,
                icon: const Icon(Icons.attach_file),
                label: const Text("Agregar evidencias"),
              ),
            ],
          ),
        ),
      ),
  
      actions: [
        TextButton(
          onPressed: _uploading
              ? null
              : () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
  
        FilledButton.icon(
          onPressed: _uploading ? null : _completeService,
          icon: _uploading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const Icon(Icons.check),
          label: Text(
            _uploading
                ? "Completando..."
                : "Completar",
          ),
        ),
      ],
    );
  }
}
