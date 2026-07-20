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
  late final TextEditingController _observationController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _observationController = TextEditingController();
  }

  @override
  void dispose() {
    ref.read(startServiceNotifierProvider.notifier).reset();
    _observationController.dispose();
    super.dispose();
  }

  Future<void> _startService() async {
    if (!_formKey.currentState!.validate()) return;
    
    final notifier = ref.read(startServiceNotifierProvider.notifier);
    await notifier.startService(
      widget.order.id,
      _observationController.text.trim(),
    );

    final state = ref.read(startServiceNotifierProvider);
    if (!mounted) return;

    if (state.status == Status.success) {
      await widget.onStarted();
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Servicio iniciado correctamente."),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(startServiceNotifierProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      child: Container(
        width: 420,
        padding: const EdgeInsets.all(28),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Iniciar orden de servicio",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.order.description,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _observationController,
                enabled: state.status != Status.loading,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: "Observación",
                  hintText: "Ingrese la observación del inicio del servicio",
                  alignLabelWithHint: true,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 32),
                    child: Icon(Icons.notes, color: Color(0xFFC62828)),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFC62828), width: 2),
                  ),
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? "Ingrese una observación"
                    : null,
              ),
              if (state.status == Status.error) ...[
                const SizedBox(height: 16),
                Text(
                  state.error ?? "Ocurrió un error",
                  style: const TextStyle(
                    color: Color(0xFFC62828),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: state.status == Status.loading
                        ? null
                        : () => Navigator.pop(context),
                    child: const Text(
                      "Cancelar",
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFC62828),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: state.status == Status.loading ? null : _startService,
                    child: state.status == Status.loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Iniciar",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}