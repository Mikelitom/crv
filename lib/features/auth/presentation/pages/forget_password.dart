import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/email_field.dart';
import '../widgets/password_field.dart';
import '../providers/auth_notifier_provider.dart';

import 'package:pinput/pinput.dart'; 

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});
  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final PageController _pageController = PageController();
  final emailController = TextEditingController();
  final pinputController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  String? emailError;
  String? tokenError;
  String? passwordError;
  bool isLoading = false;
  int _start = 900;
  Timer? _timer;

  void _startTimer() {
    _timer?.cancel();
    _start = 900;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_start == 0) { t.cancel(); setState(() {}); } 
      else { setState(() => _start--); }
    });
  }

  String get _timerText => 
      '${(_start ~/ 60).toString().padLeft(2, '0')}:${(_start % 60).toString().padLeft(2, '0')}';

  // --- ACCIONES ---

  void _handleSendEmail() async {
    if (emailController.text.isEmpty) {
      setState(() => emailError = "El correo es obligatorio");
      return;
    }
    setState(() => isLoading = true);
    final result = await ref.read(authNotifierProvider.notifier).requestPasswordReset(emailController.text.trim());
    setState(() => isLoading = false);

    result.fold(
      (failure) => setState(() => emailError = "Correo no registrado o error de red"),
      (_) {
        _startTimer();
        _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
      },
    );
  }

  void _handleVerifyToken() {
    if (pinputController.text.length < 8) {
      setState(() => tokenError = "Código incompleto");
      return;
    }
    _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
  }

  void _handleFinalReset() async {
    final p1 = passwordController.text;
    final p2 = confirmPasswordController.text;

    if (p1.length < 8) {
      setState(() => passwordError = "La contraseña debe tener al menos 8 caracteres");
      return;
    }
    if (p1 != p2) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Las contraseñas no coinciden"), backgroundColor: Colors.orange));
      return;
    }

    setState(() => isLoading = true);
    
    // FORMATEAR TOKEN: XXXX-XXXX (Aseguramos el guion antes de enviar)
    String rawToken = pinputController.text.toUpperCase();
    String formattedToken = rawToken.contains('-') 
        ? rawToken 
        : "${rawToken.substring(0, 4)}-${rawToken.substring(4)}";

    final result = await ref.read(authNotifierProvider.notifier).confirmPasswordReset(
      token: formattedToken,
      newPassword: p1,
    );
    setState(() => isLoading = false);

    result.fold(
      (f) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(f.message), backgroundColor: Colors.red)),
      (_) => _showSuccess(),
    );
  }

  void _showSuccess() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            const Text("¡Contraseña Actualizada!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            _btnAction("VOLVER AL INICIO DE SESIÓN", () { 
              Navigator.pop(context); 
              Navigator.pop(context); 
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          if (isDesktop)
            Expanded(
              child: Container(
                color: const Color(0xFFC62828),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Corregido
                    children: [
                      const Icon(Icons.lock_reset_rounded, size: 120, color: Colors.white),
                      const SizedBox(height: 20),
                      const Text("CRV Reprosisa", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _viewWrapper(_stepEmail()),
                _viewWrapper(_stepOtp()),
                _viewWrapper(_stepNewPass()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _viewWrapper(Widget child) => Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(40),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 450), // Corregido
        child: child,
      ),
    ),
  );

  Widget _stepEmail() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("Olvidé mi contraseña", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      const Text("Ingresa tu correo institucional para recibir el código de verificación.", style: TextStyle(color: Colors.grey, fontSize: 16)),
      const SizedBox(height: 40),
      EmailField(controller: emailController, errorText: emailError),
      const SizedBox(height: 40),
      _btnAction("ENVIAR CÓDIGO", _handleSendEmail),
    ],
  );

  Widget _stepOtp() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("Verifica tu correo", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      Text("El código de 8 dígitos expira en: $_timerText", style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
      const SizedBox(height: 40),
      Center(
        child: Pinput(
          length: 8,
          controller: pinputController,
          defaultPinTheme: PinTheme(
            width: 48, height: 58,
            decoration: BoxDecoration(
              color: Colors.grey.shade50, 
              borderRadius: BorderRadius.circular(10), 
              border: Border.all(color: Colors.grey.shade300)
            ),
            textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          focusedPinTheme: PinTheme(
            width: 48, height: 58,
            decoration: BoxDecoration(
              color: Colors.white, 
              borderRadius: BorderRadius.circular(10), 
              border: Border.all(color: const Color(0xFFC62828), width: 1.5)
            ),
            textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      const SizedBox(height: 40),
      _btnAction("CONTINUAR", _handleVerifyToken),
      const SizedBox(height: 20),
      Center(child: TextButton(onPressed: _start > 0 ? null : _handleSendEmail, child: const Text("Reenviar código"))),
    ],
  );

  Widget _stepNewPass() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("Establecer nueva clave", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      const SizedBox(height: 40),
      PasswordField(
        controller: passwordController, 
        labelText: "Nueva Contraseña", 
        errorText: passwordError
      ),
      const SizedBox(height: 20),
      PasswordField(
        controller: confirmPasswordController, 
        labelText: "Confirmar Contraseña"
      ),
      const SizedBox(height: 40),
      _btnAction("RESETEAR CONTRASEÑA", _handleFinalReset),
    ],
  );

  Widget _btnAction(String text, VoidCallback onTab) => SizedBox(
    width: double.infinity, height: 55,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFC62828), 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 0
      ),
      onPressed: isLoading ? null : onTab,
      child: isLoading 
          ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
          : Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
    ),
  );
}