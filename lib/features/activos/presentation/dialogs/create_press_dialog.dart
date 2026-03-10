import 'package:crv_reprosisa/features/activos/domain/params/create_press_params.dart';
import 'package:crv_reprosisa/features/activos/presentation/providers/create_press_notifier_provider.dart';
import 'package:crv_reprosisa/features/activos/presentation/providers/press_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/activos/presentation/providers/press_usecase_provider.dart';
import 'package:crv_reprosisa/features/activos/presentation/states/status.dart';
import 'package:crv_reprosisa/features/activos/presentation/widgets/base_asset_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreatePressDialog extends ConsumerStatefulWidget {
  const CreatePressDialog({super.key});

  @override
  ConsumerState<CreatePressDialog> createState() => _CreatePressDialogState();
}

class _CreatePressDialogState extends ConsumerState<CreatePressDialog> {
  final typeController = TextEditingController();
  final modelController = TextEditingController();
  final voltzController = TextEditingController();
  final serieController = TextEditingController();
  final sizeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createPressProvider);

    return BaseAssetDialog(
      title: "Registrar nueva prensa",
      onConfirm: () async {
        final press = CreatePressParams(
          type: typeController.text,
          model: modelController.text,
          voltz: voltzController.text,
          serie: serieController.text,
          size: sizeController.text,
        );

        await ref.read(createPressProvider.notifier).create(press);

        final result = ref.read(createPressProvider);

        if (result.status == Status.success) {
          ref.invalidate(pressListProvider);
          Navigator.pop(context);
        }
      },
      children: [
        if (state.status == Status.success)
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Cliente registrado correctamente",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

        buildField(typeController, "Tipo", "Hidraulica / Mecanica"),
        buildField(modelController, "Modelo", "HS-500"),
        buildField(voltzController, "Volts", "220V"),
        buildField(serieController, "Número de Serie", "SN-2026-X"),
        buildField(sizeController, "Tamaño", "5 tons"),
      ],
    );
  }
}
