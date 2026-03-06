import 'package:flutter/material.dart';

class LoginHero extends StatelessWidget {
  const LoginHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFC62828), // Color rojo oficial
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Alineación vertical central
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.print_rounded, size: 90, color: Colors.white),
            ),
            const SizedBox(height: 24),
            const Text(
              'CRV Reprosisa',
              style: TextStyle(
                color: Colors.white,
                fontSize: 38,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}