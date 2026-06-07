import 'package:flutter/material.dart';

class UserLoadingView extends StatelessWidget {
  const UserLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            // Simulación del Header
            const SizedBox(height: 50),
            // Indicador central
            Center(
              child: Column(
                children: [
                  const CircularProgressIndicator(color: Color(0xFFC62828)),
                  const SizedBox(height: 16),
                  Text("Cargando usuarios...", 
                    style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}