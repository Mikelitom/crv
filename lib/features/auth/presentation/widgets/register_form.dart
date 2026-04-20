import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_notifier_provider.dart';
import '../providers/auth_status.dart';
import 'email_field.dart';
import 'password_field.dart';

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? nameErr, emailErr, phoneErr, passErr, confirmPassErr;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool _validate() {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final passRegex = RegExp(r'^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$&*~]).{8,}$');
    
    bool hasSequentialNumbers(String text) {
      for (int i = 0; i < text.length - 2; i++) {
        var a = int.tryParse(text[i]);
        var b = int.tryParse(text[i + 1]);
        var c = int.tryParse(text[i + 2]);
        if (a != null && b != null && c != null) {
          if (b == a + 1 && c == b + 1) return true;
        }
      }
      return false;
    }

    setState(() {
      nameErr = nameController.text.trim().isEmpty ? "El nombre es obligatorio" : null;
      emailErr = !emailRegex.hasMatch(emailController.text.trim()) ? "Formato de correo incorrecto" : null;
      
      final pVal = phoneController.text.trim();
      // Si hay algo escrito, validamos que sean 10. Si está vacío, está bien.
      phoneErr = (pVal.isNotEmpty && pVal.length < 10) ? "Mínimo 10 dígitos" : null;
      
      String pass = passwordController.text;
      if (pass.isEmpty) {
        passErr = "La contraseña es obligatoria";
      } else if (!passRegex.hasMatch(pass)) {
        passErr = "Mín. 8 caracteres, Mayúscula, Número y Símbolo";
      } else if (hasSequentialNumbers(pass)) {
        passErr = "No use números secuenciales (ej. 123)";
      } else {
        passErr = null;
      }

      confirmPassErr = confirmPasswordController.text != passwordController.text ? "Las contraseñas no coinciden" : null;
    });

    return nameErr == null && emailErr == null && phoneErr == null && passErr == null && confirmPassErr == null;
  }

  void _showToast(String message, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1C1E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(isError ? Icons.error_outline : Icons.check_circle, color: isError ? Colors.redAccent : Colors.greenAccent),
              const SizedBox(width: 12),
              Expanded(child: Text(message, style: const TextStyle(color: Colors.white, fontSize: 13))),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (c) => Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.green, size: 70),
            const SizedBox(height: 20),
            const Text("Registro exitoso", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text("Tu cuenta ha sido creada. Por favor, inicia sesión.", textAlign: TextAlign.center),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC62828),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text("IR A INICIAR SESIÓN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (!_validate()) return;

    setState(() {
      emailErr = null;
      phoneErr = null;
    });

    // LÓGICA DE ENVÍO: 
    // Si el campo está vacío, mandamos una cadena que el backend ignore o null.
    // La mayoría de los backends de FastAPI esperan que si el campo es opcional, 
    // simplemente no se envíe o sea null real.
    final String? phoneVal = phoneController.text.trim().isEmpty ? null : phoneController.text.trim();

    await ref.read(authNotifierProvider.notifier).register(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      // Usamos una verificación aquí. Si tu función register no acepta null, 
      // manda un String vacío, pero lo ideal es que el notifier maneje el null.
      phone: phoneVal ?? "", 
    );

    final authState = ref.read(authNotifierProvider);

    if (authState.status == AuthStatus.authenticated) {
      await ref.read(authNotifierProvider.notifier).logout();
      if (mounted) _showSuccessSheet();
    } 
    else if (authState.error != null) {
      final String msg = authState.error!.message.toLowerCase();

      setState(() {
        if (msg.contains('email')) {
          emailErr = "Correo ya registrado";
          _showToast("El correo ya existe", true);
        } 
        else if (msg.contains('phone') || msg.contains('teléfono') || msg.contains('telefono')) {
          phoneErr = "Teléfono ya registrado";
          _showToast("El teléfono ya existe", true);
        } 
        else {
          _showToast("Error: ${authState.error!.message}", true);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authNotifierProvider).status == AuthStatus.loading;
    final isMobile = MediaQuery.of(context).size.width < 850;

    return Container(
      color: Colors.white,
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 32 : 50, vertical: 40),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Crear Cuenta', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
                const SizedBox(height: 40),
                _label('Nombre Completo'),
                _buildField(nameController, "Nombre de usuario", Icons.person_outline, nameErr),
                const SizedBox(height: 20),
                _label('Correo electrónico'),
                EmailField(controller: emailController, errorText: emailErr),
                const SizedBox(height: 20),
                _label('Teléfono (Opcional)'),
                _buildField(phoneController, "10 dígitos", Icons.phone_android_outlined, phoneErr, isPhone: true),
                const SizedBox(height: 20),
                _label('Contraseña'),
                PasswordField(controller: passwordController, errorText: passErr),
                const SizedBox(height: 20),
                _label('Confirmar contraseña'),
                PasswordField(
                  controller: confirmPasswordController, 
                  errorText: confirmPassErr,
                  onSubmitted: (_) => _handleRegister(),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC62828),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: isLoading ? null : _handleRegister,
                    child: isLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('REGISTRARSE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("¿Ya tiene una cuenta? Inicie sesión", style: TextStyle(color: Color(0xFFC62828), fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 8),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
  );

  Widget _buildField(TextEditingController controller, String hint, IconData icon, String? error, {bool isPhone = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, size: 20, color: error != null ? Colors.red : Colors.grey.shade600),
        hintText: hint,
        errorText: error,
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        contentPadding: const EdgeInsets.all(18),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFC62828))),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.red.shade200)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 1.5)),
      ),
    );
  }
}