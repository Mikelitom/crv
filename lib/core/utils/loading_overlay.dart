// Core/utils/loading_overlay.dart
import 'package:flutter/material.dart';

class LoadingOverlay {
  static void show(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false, // El usuario no puede cerrar la carga tocando afuera
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              const CircularProgressIndicator(color: Color(0xFFC62828)),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }
}