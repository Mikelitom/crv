import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CaptureMethodSelector extends StatefulWidget {
  final VoidCallback onManualFill;
  final Function(XFile? image) onImageCaptured;

  const CaptureMethodSelector({
    super.key,
    required this.onManualFill,
    required this.onImageCaptured,
  });

  @override
  State<CaptureMethodSelector> createState() => _CaptureMethodSelectorState();
}

class _CaptureMethodSelectorState extends State<CaptureMethodSelector> {
  int selectedMethod = 0;
  final ImagePicker _picker = ImagePicker();

  // Función que muestra un visor estilo escáner de documentos antes de abrir la cámara/galería
  void _showDocumentScannerModal() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.document_scanner_rounded,
                          color: Color(0xFFC62828),
                          size: 22,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Escáner de Documentos",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1A1C1E),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Color(0xFF616161),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  "Alinea el documento completo dentro del rectángulo delimitador.",
                  style: TextStyle(fontSize: 12, color: Color(0xFF616161)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // --- MARCO RECTANGULAR GRANDE PARA DOCUMENTOS ---
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFC62828),
                        width: 2.5,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Fondo o icono guía tenue
                        const Icon(
                          Icons.description_outlined,
                          color: Colors.white12,
                          size: 80,
                        ),

                        // Esquinas de enfoque muy notorias tipo escáner profesional
                        Positioned(
                          top: 20,
                          left: 20,
                          child: _buildLargeCornerBorder(top: true, left: true),
                        ),
                        Positioned(
                          top: 20,
                          right: 20,
                          child: _buildLargeCornerBorder(
                            top: true,
                            left: false,
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 20,
                          child: _buildLargeCornerBorder(
                            top: false,
                            left: true,
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          right: 20,
                          child: _buildLargeCornerBorder(
                            top: false,
                            left: false,
                          ),
                        ),

                        // Texto indicador dentro del visor
                        Positioned(
                          bottom: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              "Área de captura de documento",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Botón de disparo de captura real
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC62828),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _openCameraSafe();
                    },
                    icon: const Icon(Icons.camera_alt_rounded, size: 20),
                    label: const Text(
                      "Tomar Fotografía del Documento",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Esquinas de gran tamaño para delimitar hojas/documentos
  Widget _buildLargeCornerBorder({required bool top, required bool left}) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        border: Border(
          top: top
              ? const BorderSide(color: Colors.white, width: 4)
              : BorderSide.none,
          bottom: !top
              ? const BorderSide(color: Colors.white, width: 4)
              : BorderSide.none,
          left: left
              ? const BorderSide(color: Colors.white, width: 4)
              : BorderSide.none,
          right: !left
              ? const BorderSide(color: Colors.white, width: 4)
              : BorderSide.none,
        ),
      ),
    );
  }

  Future<void> _openCameraSafe() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (photo != null) {
        widget.onImageCaptured(photo);
      }
    } catch (e) {
      debugPrint("Error al abrir la cámara: $e");
      try {
        final XFile? fallbackFile = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 85,
        );
        if (fallbackFile != null) {
          widget.onImageCaptured(fallbackFile);
        }
      } catch (fallbackError) {
        debugPrint("Error en selector alternativo: $fallbackError");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.document_scanner_rounded,
                    color: Color(0xFFC62828),
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Método de Captura de Datos",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: isMobile ? 15 : 17,
                        color: const Color(0xFF1A1C1E),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "Seleccione el método para ingresar la información",
                style: TextStyle(
                  color: const Color(0xFF616161),
                  fontSize: isMobile ? 12 : 13,
                ),
              ),
              const SizedBox(height: 20),
              Flex(
                direction: isMobile ? Axis.vertical : Axis.horizontal,
                children: [
                  _buildCompactButton(
                    0,
                    "Llenado Manual",
                    Icons.edit_note_rounded,
                    widget.onManualFill,
                    isMobile,
                  ),
                  if (isMobile)
                    const SizedBox(height: 12)
                  else
                    const SizedBox(width: 16),
                  _buildCompactButton(
                    1,
                    kIsWeb ? "Cargar Documento" : "Escanear Documento",
                    Icons.document_scanner_rounded,
                    _showDocumentScannerModal, // Muestra el marco grande de documentos antes de abrir la cámara
                    isMobile,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCompactButton(
    int index,
    String label,
    IconData icon,
    VoidCallback onTap,
    bool isMobile,
  ) {
    bool isSelected = selectedMethod == index;
    return Expanded(
      flex: isMobile ? 0 : 1,
      child: InkWell(
        onTap: () {
          setState(() => selectedMethod = index);
          onTap();
        },
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: isMobile ? double.infinity : null,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFC62828)
                : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFC62828)
                  : const Color(0xFFE0E0E0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : const Color(0xFF616161),
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF1A1C1E),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
