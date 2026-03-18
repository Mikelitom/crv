import 'package:flutter/material.dart';
import '../widgets/email_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  String? emailError; // Estado del error
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  // FUNCIÓN DE VALIDACIÓN DE CORREO
  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (email.isEmpty) {
      setState(() => emailError = "El correo es obligatorio");
      return false;
    } else if (!emailRegex.hasMatch(email)) {
      setState(() => emailError = "Formato de correo no válido (ej: usuario@dominio.com)");
      return false;
    }
    setState(() => emailError = null);
    return true;
  }

  void _handleResetPassword() async {
    if (!_validateEmail(emailController.text.trim())) return;

    setState(() => isLoading = true);
    
    // Simulación de API
    await Future.delayed(const Duration(seconds: 2)); 

    if (mounted) {
      setState(() => isLoading = false);
      _showSuccessSheet(); // Ahora es un BottomSheet más moderno que un Dialog
    }
  }

  void _showSuccessSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 80, width: 80,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.mark_email_read_outlined, color: Colors.green, size: 40),
            ),
            const SizedBox(height: 24),
            const Text("¡Correo Enviado!", 
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(
              "Hemos enviado un enlace de recuperación a ${emailController.text}. Revisa tu bandeja de entrada y carpeta de spam.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, height: 1.5),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC62828),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.pop(context); // Cierra Sheet
                  Navigator.pop(context); // Regresa al Login
                },
                child: const Text("ENTENDIDO, VOLVER", 
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                children: [
                  // Ícono decorativo más bonito
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDECEA),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(Icons.lock_reset_rounded, 
                      color: Color(0xFFC62828), size: 50),
                  ),
                  const SizedBox(height: 32),
                  const Text("¿Problemas para entrar?", 
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1A1C1E))),
                  const SizedBox(height: 12),
                  Text("Ingresa tu correo y te ayudaremos a recuperar el acceso a tu cuenta de CRV Reprosisa.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 15, height: 1.5)),
                  const SizedBox(height: 48),
                  
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text("Correo institucional", 
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                  const SizedBox(height: 10),
                  
                  // El campo de correo ahora recibe el error
                  EmailField(
                    controller: emailController,
                    errorText: emailError, 
                  ),
                  
                  const SizedBox(height: 40),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC62828),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 0,
                      ),
                      onPressed: isLoading ? null : _handleResetPassword,
                      child: isLoading 
                        ? const SizedBox(height: 20, width: 20, 
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text("ENVIAR INSTRUCCIONES", 
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancelar", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}