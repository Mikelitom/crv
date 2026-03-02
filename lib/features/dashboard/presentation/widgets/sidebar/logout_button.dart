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

    return ElevatedButton.icon(
      onPressed: isLoading
          ? null
          : () async {
              await ref.read(authNotifierProvider.notifier).logout();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Sesion cerrada correctamente")),
              );
              Navigator.pushReplacementNamed(context, '/login');
            },
      icon: isLoading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.logout),
      label: showLabel ? const Text('Cerrar sesion') : const SizedBox.shrink(),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
