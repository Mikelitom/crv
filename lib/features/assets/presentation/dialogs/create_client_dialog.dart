import 'package:crv_reprosisa/features/assets/domain/params/create_clients_params.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/client_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/create_client_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/clients_list_state.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:crv_reprosisa/features/assets/presentation/widgets/base_asset_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MineFormData {
  final TextEditingController nameController;
  final TextEditingController addressController;
  final TextEditingController phoneController;
  final TextEditingController emailController;

  MineFormData({
    TextEditingController? nameController,
    TextEditingController? addressController,
    TextEditingController? phoneController,
    TextEditingController? emailController,
  }) : nameController = nameController ?? TextEditingController(),
       addressController = addressController ?? TextEditingController(),
       phoneController = phoneController ?? TextEditingController(),
       emailController = emailController ?? TextEditingController();

  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    emailController.dispose();
  }
}

class CreateClientDialog extends ConsumerStatefulWidget {
  const CreateClientDialog({super.key});

  @override
  ConsumerState<CreateClientDialog> createState() => _CreateClientDialogState();
}

class _CreateClientDialogState extends ConsumerState<CreateClientDialog> {
  final _formKey = GlobalKey<FormState>();

  // CLIENTE
  final nameController = TextEditingController();
  final companyController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  // MINAS
  final List<MineFormData> mines = [];

  bool _success = false;

  @override
  void initState() {
    super.initState();

    // Mina inicial
    mines.add(MineFormData());

    ref.listenManual(createClientProvider, (previous, next) async {
      if (!mounted) return;

      if (next.status == Status.success) {
        setState(() => _success = true);

        ref.read(clientListProvider.notifier).loadClients();

        await Future.delayed(const Duration(seconds: 1));

        if (!mounted) return;

        Navigator.pop(context, true);
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
  void dispose() {
    nameController.dispose();
    companyController.dispose();
    phoneController.dispose();
    emailController.dispose();

    for (final mine in mines) {
      mine.dispose();
    }

    super.dispose();
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
              if (!_formKey.currentState!.validate()) {
                return;
              }

              final params = CreateClientParams(
                name: nameController.text.trim(),
                company: companyController.text.trim(),
                phone: phoneController.text.trim(),
                email: emailController.text.trim(),

                mines: mines.map((mine) {
                  return CreateMineParams(
                    name: mine.nameController.text.trim(),
                    address: mine.addressController.text.trim(),
                    phone: mine.phoneController.text.trim(),
                    email: mine.emailController.text.trim(),
                  );
                }).toList(),
              );

              await ref.read(createClientProvider.notifier).create(params);
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

  Widget _buildForm(ClientsListState clientsState) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          key: const ValueKey("form"),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildClientSection(clientsState),

            const SizedBox(height: 24),

            _buildMinesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildClientSection(ClientsListState clientsState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Información del cliente",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 16),

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
            if (value == null || value.isEmpty) {
              return null;
            }

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
            if (value == null || value.isEmpty) {
              return null;
            }

            final exists = clientsState.clients.any(
              (c) => c.email == emailController.text.trim(),
            );

            if (exists) {
              return "Email ya registrado";
            }

            final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');

            if (!regex.hasMatch(value)) {
              return "Email inválido";
            }

            return null;
          },
        ),
      ],
    );
  }

  Widget _buildMinesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Minas",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            IconButton(
              onPressed: () {
                setState(() {
                  mines.add(MineFormData());
                });
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),

        const SizedBox(height: 8),

        ...List.generate(mines.length, (index) {
          return MineFormWidget(
            mine: mines[index],
            index: index,

            onRemove: mines.length == 1
                ? null
                : () {
                    setState(() {
                      mines[index].dispose();
                      mines.removeAt(index);
                    });
                  },
          );
        }),
      ],
    );
  }

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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class MineFormWidget extends StatelessWidget {
  final MineFormData mine;
  final int index;
  final VoidCallback? onRemove;

  const MineFormWidget({
    super.key,
    required this.mine,
    required this.index,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Mina ${index + 1}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                if (onRemove != null)
                  IconButton(
                    onPressed: onRemove,
                    icon: const Icon(Icons.delete),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            buildField(
              mine.nameController,
              "Nombre de mina",
              "Mina Norte",
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Nombre obligatorio";
                }

                return null;
              },
            ),

            buildField(mine.addressController, "Dirección", "Dirección..."),

            buildField(mine.phoneController, "Teléfono", "+52..."),

            buildField(mine.emailController, "Email", "mina@empresa.com"),
          ],
        ),
      ),
    );
  }
}
