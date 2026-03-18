import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/auth/presentation/providers/auth_notifier_provider.dart';
import 'package:crv_reprosisa/features/auth/presentation/providers/auth_status.dart';

class LoginButton extends ConsumerWidget {
  final VoidCallback onAction;
  final bool isBlocked;

  const LoginButton({super.key, required this.onAction, required this.isBlocked});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.status == AuthStatus.loading;

    return SizedBox(
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFC62828),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        onPressed: isLoading
            ? null
            : () async {
                final email = emailController.text.trim();
                final password = passwordController.text.trim();

                print("Login presionado: $email, $password");

                await ref.read(authNotifierProvider.notifier).login(email, password);

                if (!context.mounted) return;

                final updatedState = ref.read(authNotifierProvider);

                if (updatedState.error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(updatedState.error.toString())),
                  );
                }
              },
>>>>>>> fix/profile
        child: isLoading
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text('Iniciar Sesión', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
