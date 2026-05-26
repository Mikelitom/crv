import 'package:crv_reprosisa/features/assets/domain/entities/clients.dart';
import 'package:crv_reprosisa/features/assets/domain/params/create_clients_params.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/client_actions_providers.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/client_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/update_client_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:crv_reprosisa/features/assets/presentation/widgets/base_asset_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateClientDialog extends ConsumerStatefulWidget {
  final Clients client;
  const UpdateClientDialog({super.key, required this.client});

  @override
  ConsumerState<UpdateClientDialog> createState() => _UpdateClientDialogState();
}

class _UpdateClientDialogState extends ConsumerState<UpdateClientDialog> {
  final _formKey = GlobalKey<FormState>();
  final Color primaryColor = const Color(0xFF8B0000);

  late TextEditingController nameController;
  late TextEditingController companyController;
  late TextEditingController phoneController;
  late TextEditingController emailController;

  late List<CreateMineParams> _mines;
  bool _success = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.client.name);
    companyController = TextEditingController(text: widget.client.company);
    phoneController = TextEditingController(text: widget.client.phone);
    emailController = TextEditingController(text: widget.client.email ?? "");

    _mines = (widget.client.mines ?? []).map((m) => CreateMineParams(
      id: m.id, name: m.name, address: m.address, phone: m.phone, email: m.email,
      isActive: m.isActive,
    )).toList();

    ref.listenManual(updateClientProvider, (previous, next) async {
      if (!mounted) return;
      if (next.status == Status.success) {
        setState(() => _success = true);
        ref.read(clientListProvider.notifier).loadClients();
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) Navigator.pop(context, true);
      }
    });
  }

  Future<bool> _showConfirmationDialog(String title, String content) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancelar")),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: primaryColor),
            onPressed: () => Navigator.pop(context, true), 
            child: const Text("Confirmar")
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(updateClientProvider);
    return BaseAssetDialog(
      title: _success ? "" : "Editar Cliente",
      onConfirm: _success ? null : () async {
        if (!_formKey.currentState!.validate()) return;
        bool confirm = await _showConfirmationDialog("Guardar", "¿Seguro que deseas guardar cambios?");
        if (!confirm) return;
        
        final params = CreateClientParams(
          name: nameController.text.trim(),
          company: companyController.text.trim(),
          phone: phoneController.text.trim(),
          email: emailController.text.trim(),
          mines: _mines,
        );
        await ref.read(updateClientProvider.notifier).update(widget.client.id, params);
      },
      isLoading: state.status == Status.loading && !_success,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _success ? _buildSuccessState() : _buildForm(),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField(nameController, "Nombre", Icons.person_outline),
          _buildTextField(companyController, "Empresa", Icons.business_outlined),
          _buildTextField(phoneController, "Teléfono", Icons.phone_android),
          _buildTextField(emailController, "Email", Icons.email_outlined),
          const Divider(height: 30),
          _buildHeader("MINAS ASOCIADAS", Icons.landscape_outlined),
          const SizedBox(height: 12),
          // Usamos un loop simple para renderizar todas
          ..._mines.asMap().entries.map((entry) => _buildMineCard(entry.key)),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => setState(() => _mines.add(const CreateMineParams(name: '', isActive: true))),
            icon: const Icon(Icons.add),
            label: const Text("Añadir Mina"),
            style: OutlinedButton.styleFrom(foregroundColor: primaryColor, side: BorderSide(color: primaryColor)),
          ),
        ],
      ),
    );
  }

  Widget _buildMineCard(int index) {
    final mine = _mines[index];
    final isEnabled = mine.isActive;

    return Container(
      key: ValueKey("${mine.id}_$index"), // <--- ESTO ES LO QUE OBLIGA A REFRESCAR LA UI
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isEnabled ? Colors.white : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isEnabled ? Colors.grey.shade300 : Colors.red.shade200),
      ),
      child: ExpansionTile(
        title: Text(mine.name.isEmpty ? "Nueva Mina" : mine.name, 
                    style: TextStyle(fontWeight: FontWeight.w600, color: isEnabled ? Colors.black : Colors.grey, decoration: isEnabled ? null : TextDecoration.lineThrough)),
        subtitle: isEnabled ? null : const Text("Deshabilitada", style: TextStyle(color: Colors.red, fontSize: 10)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSubField("Nombre", mine.name, (v) => setState(() => _mines[index] = _mines[index].copyWith(name: v))),
                _buildSubField("Dirección", mine.address ?? "", (v) => setState(() => _mines[index] = _mines[index].copyWith(address: v))),
                Row(
                  children: [
                    Expanded(child: _buildSubField("Teléfono", mine.phone ?? "", (v) => setState(() => _mines[index] = _mines[index].copyWith(phone: v)))),
                    const SizedBox(width: 8),
                    Expanded(child: _buildSubField("Email", mine.email ?? "", (v) => setState(() => _mines[index] = _mines[index].copyWith(email: v)))),
                  ],
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () async {
                    bool isEnabled = _mines[index].isActive;
                    String action = isEnabled ? "deshabilitar" : "habilitar";
                    
                    bool confirm = await _showConfirmationDialog("Confirmar acción", "¿Seguro que deseas $action esta mina?");
                    if (confirm) {
                      // 1. Cambiamos el estado local inmediatamente para que la UI responda rápido (Optimistic Update)
                      setState(() {
                        _mines[index] = _mines[index].copyWith(isActive: !isEnabled);
                      });

                      final mineId = _mines[index].id;
                      
                      // 2. Solo hacemos petición a la API si la mina ya existe en el servidor
                      if (mineId != null && mineId.isNotEmpty) {
                        try {
                          if (isEnabled) {
                            // Llamada al provider que hace el "soft delete" (deshabilitar en backend)
                            await ref.read(deleteMineProvider.notifier).delete(mineId);
                          } else {
                            // Llamada al provider para habilitar (si tienes este provider configurado)
                            await ref.read(activateMineProvider.notifier).activate(mineId);
                          }
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Mina ${isEnabled ? 'deshabilitada' : 'habilitada'}.")),
                          );
                        } catch (e) {
                          // Si falla la API, revertimos el cambio localmente
                          setState(() {
                            _mines[index] = _mines[index].copyWith(isActive: isEnabled);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Error al actualizar el servidor"), backgroundColor: Colors.red),
                          );
                        }
                      }
                    }
                  },
                  icon: Icon(isEnabled ? Icons.block : Icons.check_circle_outline, 
                             color: isEnabled ? Colors.redAccent : Colors.green, size: 18),
                  label: Text(isEnabled ? "Deshabilitar Mina" : "Habilitar Mina", 
                              style: TextStyle(color: isEnabled ? Colors.redAccent : Colors.green)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeader(String title, IconData icon) => Row(
    children: [
      Icon(icon, size: 20, color: primaryColor),
      const SizedBox(width: 8),
      Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
    ],
  );

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        validator: (v) => (v == null || v.isEmpty) ? "Requerido" : null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: primaryColor),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor, width: 2)),
        ),
      ),
    );
  }

  Widget _buildSubField(String label, String initialValue, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(labelText: label, isDense: true, border: const OutlineInputBorder()),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSuccessState() => const SizedBox(
    height: 200, 
    child: Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle_outline, color: Colors.green, size: 80),
        SizedBox(height: 10),
        Text("Registro Exitoso", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
      ],
    ))
  );
}