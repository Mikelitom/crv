import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; 
import '../providers/auth_notifier_provider.dart';
import '../providers/auth_status.dart';
import 'email_field.dart';
import 'password_field.dart';   
import 'login_button.dart';
import 'remember_me_checkbox.dart';
import 'forgot_password_button.dart';
import '../pages/register_page.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final storage = const FlutterSecureStorage(); 
  
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  String? emailError;
  String? passwordError;
  bool rememberMe = true; 
  int failedAttempts = 0;
  bool isBlocked = false;
  int secondsRemaining = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    timer?.cancel();
    super.dispose();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('saved_email');
    final savedPassword = await storage.read(key: 'saved_password');

    if (savedEmail != null || savedPassword != null) {
      if (mounted) {
        setState(() {
          emailController.text = savedEmail ?? '';
          passwordController.text = savedPassword ?? '';
          rememberMe = true; 
        });
      }
    }
  }

  void _startBlockTimer() {
    setState(() {
      isBlocked = true;
      secondsRemaining = 30;
    });
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        if (secondsRemaining > 0) {
          secondsRemaining--;
        } else {
          isBlocked = false;
          failedAttempts = 0;
          t.cancel();
        }
      });
    });
  }

  void _showToast(String message, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
          child: Row(
            children: [
              Container(width: 4, height: 20, color: isError ? Colors.red : Colors.green),
              const SizedBox(width: 12),
              Icon(isError ? Icons.error_outline : Icons.check_circle_outline, color: isError ? Colors.red : Colors.green),
              const SizedBox(width: 12),
              Expanded(child: Text(message, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500))),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin([String? _]) async {
    if (isBlocked) return;

    final email = emailController.text.trim();
    final pass = passwordController.text.trim();
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    setState(() {
      emailError = email.isEmpty ? "Ingrese su correo" : (!emailRegex.hasMatch(email) ? "Correo inválido" : null);
      passwordError = pass.isEmpty ? "Ingrese su contraseña" : null;
    });

    if (emailError != null || passwordError != null) return;

    await ref.read(authNotifierProvider.notifier).login(email, pass);
    final state = ref.read(authNotifierProvider);

    if (state.status == AuthStatus.authenticated) {
      final prefs = await SharedPreferences.getInstance();
      if (rememberMe) {
        await prefs.setString('saved_email', email);
        await prefs.setBool('remember_me', true);
        await storage.write(key: 'saved_password', value: pass); 
      }
    } else {
      if (mounted) {
        setState(() => failedAttempts++);
        if (failedAttempts >= 3) _startBlockTimer();
        _showToast("Correo o contraseña incorrectos", true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // El logo ahora se muestra siempre (Móvil, Tablet y Desktop)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Image.asset(
                    'assets/images/logo_reprosisa.png', 
                    height: 100, 
                    fit: BoxFit.contain,
                    errorBuilder: (c, e, s) => const Icon(
                      Icons.print, 
                      size: 80, 
                      color: Color(0xFFC62828)
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Acceso al Sistema', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              const Text('Correo electrónico', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              EmailField(
                controller: emailController, 
                errorText: emailError,
                focusNode: emailFocus,
                onSubmitted: (_) => FocusScope.of(context).requestFocus(passwordFocus),
              ),
              const SizedBox(height: 24),
              const Text('Contraseña', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              PasswordField(
                controller: passwordController, 
                errorText: passwordError, 
                focusNode: passwordFocus,
                onSubmitted: _handleLogin, 
              ),
              const SizedBox(height: 16),
              if (isBlocked) 
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text('Sistema bloqueado por $secondsRemaining seg.', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RememberMeCheckbox(
                    value: rememberMe, 
                    onChanged: (v) => setState(() => rememberMe = v ?? false)
                  ),
                  const ForgotPasswordButton(),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity, 
                child: LoginButton(isBlocked: isBlocked, onAction: _handleLogin)
              ),
              const SizedBox(height: 24),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, 
                  children: [
                    const Text('¿Usuario nuevo? ', style: TextStyle(color: Colors.grey)),
                    TextButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const RegisterPage())), 
                      child: const Text('Regístrate aquí', style: TextStyle(color: Color(0xFFC62828), fontWeight: FontWeight.bold))
                    ),
                  ]
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}