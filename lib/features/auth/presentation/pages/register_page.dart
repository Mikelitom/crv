import 'package:flutter/material.dart';
import '../widgets/email_field.dart';
import '../widgets/password_field.dart';


class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Diseño responsivo: 850px es tu punto de corte
          if (constraints.maxWidth >= 850) {
            return Row(
              children: [
                // LADO IZQUIERDO: Idéntico al Login 
                const Expanded(child: _RegisterHero()), 
                // LADO DERECHO: Formulario
                const Expanded(child: _RegisterForm()), 
              ],
            );
          }
          // En móvil solo mostramos el formulario
          return const _RegisterForm();
        },
      ),
    );
  }
}

// --- LADO IZQUIERDO (HERO) EXACTAMENTE IGUAL AL LOGIN ---
class _RegisterHero extends StatelessWidget {
  const _RegisterHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFC62828), // Tu rojo oficial
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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

// --- LADO DERECHO (FORMULARIO) ---
class _RegisterForm extends StatelessWidget {
  const _RegisterForm();

  @override
  Widget build(BuildContext context) {
    // Definimos el estilo Black para el título sin 'const' para evitar errores
    final TextStyle titleStyle = TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.normal,
      color: Colors.black87,
    );

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Crear Cuenta', style: titleStyle),
              const SizedBox(height: 8),
              const Text(
                'Regístrese para solicitar acceso al sistema',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              
              const SizedBox(height: 40),

              _label('Nombre Completo'),
              _buildField('Ej. Carlos Ramírez', Icons.person_outline),

              const SizedBox(height: 20),

              _label('Email Institucional'),
              // Reutilizamos tu widget EmailField
              EmailField(controller: TextEditingController()),

              const SizedBox(height: 20),

              _label('Teléfono'),
              _buildField('+52 ...', Icons.phone_android_outlined),

              const SizedBox(height: 20),

              _label('Contraseña'),
              // Reutilizamos tu widget PasswordField
              PasswordField(controller: TextEditingController()),

              const SizedBox(height: 40),

              // BOTÓN REGISTRAR
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC62828),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    // Al terminar, volvemos al login
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Registrarse', 
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿Ya tienes cuenta?', style: TextStyle(color: Colors.grey)),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Inicia sesión',
                        style: TextStyle(color: Color(0xFFC62828), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 8),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
  );

  Widget _buildField(String hint, IconData icon) {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey, size: 20),
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        contentPadding: const EdgeInsets.all(18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDEE2E6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFC62828), width: 1.5),
        ),
      ),
    );
  }
}