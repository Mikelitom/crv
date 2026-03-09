import 'package:crv_reprosisa/features/activos/domain/params/create_clients_params.dart';
import 'package:crv_reprosisa/features/activos/presentation/providers/client_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/activos/presentation/providers/create_client_notifier_provider.dart';
import 'package:crv_reprosisa/features/activos/presentation/states/status.dart';
import 'package:crv_reprosisa/features/activos/presentation/widgets/base_asset_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateClientDialog extends ConsumerStatefulWidget {
  const CreateClientDialog({super.key});

  @override
  ConsumerState<CreateClientDialog> createState() => _CreateClientDialogState();
}

class _CreateClientDialogState extends ConsumerState<CreateClientDialog> {
  final nameController = TextEditingController();
  final companyController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createClientProvider);

    return BaseAssetDialog(
      title: "Registrar nuevo cliente",
      onConfirm: () async {
        final client = CreateClientParams(
          name: nameController.text,
          company: companyController.text,
          phone: phoneController.text,
          email: emailController.text,
          address: addressController.text,
        );

        await ref.read(createClientProvider.notifier).create(client);

        final result = ref.read(createClientProvider);

        if (result.status == Status.success) {
          ref.invalidate(clientListProvider);
          Navigator.pop(context);
        }
      },
      isLoading: state.status == Status.loading,
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

        buildField(nameController, "Nombre Completo", "Ej. Juan Perez"),
        buildField(companyController, "Empresa", "Minera del Norte"),
        buildField(phoneController, "Teléfono", "+52 444..."),
        buildField(emailController, "Email", "cliente@ejemplo.com"),
        buildField(
          addressController,
          "Direccion / Minas",
          "Mina Santa Fe, Mina Norte",
          maxLines: 2,
        ),
      ],
    );
  }
}
