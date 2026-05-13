import 'package:crv_reprosisa/features/auth/presentation/providers/auth_notifier_provider.dart';
import 'package:crv_reprosisa/features/auth/presentation/providers/auth_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogoutButton extends ConsumerWidget {
  final bool showLabel;

  const LogoutButton({super.key, this.showLabel = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.status == AuthStatus.loading;
    const Color primaryRed = Color(0xFFC62828);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextButton.icon(
        onPressed: isLoading
            ? null
            : () async {
                await ref.read(authNotifierProvider.notifier).logout();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Sesión cerrada correctamente")),
                  );
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
        icon: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: primaryRed),
              )
            : const Icon(Icons.logout_rounded, color: primaryRed),
        label: showLabel 
            ? const Text(
                'Cerrar sesión', 
                style: TextStyle(color: primaryRed, fontWeight: FontWeight.bold)
              ) 
            : const SizedBox.shrink(),
        style: TextButton.styleFrom(
          backgroundColor: primaryRed.withOpacity(0.1),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}