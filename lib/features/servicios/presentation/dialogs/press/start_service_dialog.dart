import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:crv_reprosisa/features/servicios/data/models/press/press_service_order_model.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/service_press_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StartPressServiceDialog extends ConsumerStatefulWidget {
  final PressServiceOrderModel order;
  final Future<void> Function() onStarted;

  const StartPressServiceDialog({
    super.key,
    required this.order,
    required this.onStarted,
  });

  @override
  ConsumerState<StartPressServiceDialog> createState() =>
      _StartPressServiceDialogState();
}

class _StartPressServiceDialogState
    extends ConsumerState<StartPressServiceDialog> {
  final _observationController = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _observationController.dispose();
    super.dispose();
  }

  Future<void> _startService() async {
    final observation = _observationController.text.trim();

    if (observation.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Debe ingresar una observación."),
        ),
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      await ref
          .read(startServiceNotifierProvider.notifier)
          .startService(
            widget.order.id,
            observation,
          );

      final state = ref.read(startServiceNotifierProvider);

      if (!mounted) return;

      if (state.status == Status.success) {
        await widget.onStarted();

        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Servicio iniciado correctamente."),
          ),
        );

        ref.read(startServiceNotifierProvider.notifier).reset();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              state.error ?? "Ocurrió un error al iniciar el servicio.",
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Iniciar servicio"),
      content: SizedBox(
        width: 450,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.order.description,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _observationController,
              enabled: !_loading,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: "Observación",
                hintText: "Ingrese la observación del inicio del servicio",
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading
              ? null
              : () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        FilledButton.icon(
          onPressed: _loading ? null : _startService,
          icon: _loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.play_arrow),
          label: Text(
            _loading ? "Iniciando..." : "Iniciar",
          ),
        ),
      ],
    );
  }
}