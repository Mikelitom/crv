import 'package:crv_reprosisa/features/auth/presentation/providers/auth_notifier_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginButton extends ConsumerWidget {
    final TextEditingController emailController;
    final TextEditingController passwordController;

    const LoginButton({
        super.key,
        required this.emailController,
        required this.passwordController,
    });

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        final authState = ref.watch(authNotifierProvider);
        final isLoading = authState is AsyncLoading;

        return SizedBox(
            height: 48,
            child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        ref.read(authNotifierProvider.notifier).login(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                        );
                    },
                child: isLoading
                    ? const SizedBox(
                        height: 18,    
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : const Text(
                        'Ingresar',
                        style: TextStyle(fontSize: 16),
                    )
            ),
        );
    }
}
