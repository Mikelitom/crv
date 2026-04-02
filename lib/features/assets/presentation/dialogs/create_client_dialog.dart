import 'package:crv_reprosisa/features/assets/domain/params/create_clients_params.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/client_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/create_client_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/clients_list_state.dart';
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

  bool _success = false;

  @override
  void initState() {
    super.initState();

    ref.listenManual(createClientProvider, (previous, next) async {
      if (!mounted) return;

      if (next.status == Status.success) {
        setState(() => _success = true);

        // refrescar lista
        ref.read(clientListProvider.notifier).loadClients();

        // esperar para mostrar animación
        await Future.delayed(const Duration(seconds: 1));

        if (!mounted) return;
        Navigator.pop(context, true); // 🔥 importante
      }

      if (next.status == Status.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error ?? "Error al registrar cliente"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createClientProvider);
    final clientsState = ref.read(clientListProvider);

    return BaseAssetDialog(
      title: _success ? "" : "Registrar nuevo cliente",
      onConfirm: _success
          ? null
          : () async {
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
      isLoading: state.status == Status.loading && !_success,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _success ? _buildSuccessState() : _buildForm(clientsState),
        ),
      ],
    );
  }

  /// ✅ FORMULARIO
  Widget _buildForm(ClientsListState clientsState) {
    return Form(
      key: _formKey,
      child: Column(
        key: const ValueKey("form"),
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


              final exists = clientsState.clients.any((c) => c.email == emailController.text.trim());

              if (exists) return "Email ya registrado";

              final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
              if (!regex.hasMatch(value)) {
                return "Email inválido";
              }
              return null;
            },
          ),

          buildField(
            addressController,
            "Dirección / Minas",
            "Mina Santa Fe, Mina Norte",
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  /// ✅ ESTADO DE ÉXITO (palomita)
  Widget _buildSuccessState() {
    return SizedBox(
      key: const ValueKey("success"),
      height: 220,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: _success ? 1 : 0.5,
              duration: const Duration(milliseconds: 300),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  size: 60,
                  color: Colors.green.shade600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Cliente registrado",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
