import 'package:crv_reprosisa/features/assets/domain/params/create_clients_params.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/client_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/create_client_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:crv_reprosisa/features/assets/presentation/widgets/base_asset_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateClientDialog extends ConsumerStatefulWidget {
  const CreateClientDialog({super.key});

  @override
  ConsumerState<CreateClientDialog> createState() => _CreateClientDialogState();
}

class _CreateClientDialogState extends ConsumerState<CreateClientDialog> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final companyController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void initState() {
    super.initState();

    ref.listenManual(createClientProvider, (previous, next) {
      if (!mounted) return; // 🔥 CLAVE

      if (next.status == Status.success) {
        ref.read(clientListProvider.notifier).loadClients();
        Navigator.pop(context);
      }

      if (next.status == Status.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error ?? "Error al registrar cliente")),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createClientProvider);

    return BaseAssetDialog(
      title: "Registrar nuevo cliente",
      onConfirm: () async {
        // ✅ VALIDACIÓN
        if (!_formKey.currentState!.validate()) return;

        final client = CreateClientParams(
          name: nameController.text.trim(),
          company: companyController.text.trim(),
          phone: phoneController.text.trim(),
          email: emailController.text.trim(),
          address: addressController.text.trim(),
        );

        await ref.read(createClientProvider.notifier).create(client);
      },
      isLoading: state.status == Status.loading,

      // 👇 AQUÍ va el Form
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              buildField(
                nameController,
                "Nombre Completo",
                "Ej. Juan Perez",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "El nombre es obligatorio";
                  }
                  if (value.length < 3) {
                    return "Mínimo 3 caracteres";
                  }
                  return null;
                },
              ),

              buildField(companyController, "Empresa", "Minera del Norte"),

              buildField(
                phoneController,
                "Teléfono",
                "+52 444...",
                validator: (value) {
                  if (value == null || value.isEmpty) return null;

                  final regex = RegExp(r'^\+?[0-9]{10,15}$');
                  if (!regex.hasMatch(value)) {
                    return "Teléfono inválido";
                  }
                  return null;
                },
              ),

              buildField(
                emailController,
                "Email",
                "cliente@ejemplo.com",
                validator: (value) {
                  if (value == null || value.isEmpty) return null;

                  final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!regex.hasMatch(value)) {
                    return "Email inválido";
                  }
                  return null;
                },
              ),

              buildField(
                addressController,
                "Direccion / Minas",
                "Mina Santa Fe, Mina Norte",
                maxLines: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
