import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';

class OCRScannerScreen extends StatefulWidget {
  const OCRScannerScreen({super.key});

  @override
  State<OCRScannerScreen> createState() => _OCRScannerScreenState();
}

class _OCRScannerScreenState extends State<OCRScannerScreen> {
  CameraController? _cameraController;
  final TextRecognizer _textRecognizer = TextRecognizer();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      final cameras = await availableCameras();
      _cameraController = CameraController(cameras[0], ResolutionPreset.high, enableAudio: false);
      await _cameraController?.initialize();
      if (mounted) setState(() {});
    }
  }

  Future<void> _scanImage() async {
    if (_cameraController == null || _isProcessing) return;

    try {
      setState(() => _isProcessing = true);
      final image = await _cameraController!.takePicture();
      final inputImage = InputImage.fromFilePath(image.path);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      if (recognizedText.text.isNotEmpty) {
        // Retornamos el primer bloque de texto encontrado (usualmente el número de serie)
        if (mounted) Navigator.pop(context, recognizedText.text.split('\n').first);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No se detectó texto. Intenta de nuevo.")),
        );
      }
    } catch (e) {
      debugPrint("Error OCR: $e");
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Escaneo de Serie / QR"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          CameraPreview(_cameraController!),
          // Guía visual para el usuario
          Center(
            child: Container(
              width: 280,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton.extended(
                backgroundColor: const Color(0xFFC62828),
                onPressed: _isProcessing ? null : _scanImage,
                label: _isProcessing 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text("CAPTURAR CÓDIGO"),
                icon: const Icon(Icons.camera_alt),
              ),
            ),
          ),
        ],
      ),
    );
  }
}