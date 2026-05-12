import 'package:crv_reprosisa/features/profile/presentation/provider/change_password_state.dart';
import 'package:crv_reprosisa/features/profile/presentation/provider/profile_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'hover_button.dart';

class ProfileSecurityCard extends ConsumerStatefulWidget {
  const ProfileSecurityCard({super.key});

  @override
  ConsumerState<ProfileSecurityCard> createState() =>
      _ProfileSecurityCardState();
}

class _ProfileSecurityCardState
    extends ConsumerState<ProfileSecurityCard> {
  bool _logoutOthers = false;

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listener reactivo para el estado de cambio de contraseña
    ref.listen(changePasswordNotifierProvider, (prev, next) {
      if (next.status == ChangePasswordStatus.success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Contraseña actualizada. Inicia sesión nuevamente"),
          ),
        );
      }

      if (next.status == ChangePasswordStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.failure?.message ?? "Error inesperado"),
          ),
        );
      }
    });

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 25,
              offset: const Offset(0, 10)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Column(
          children: [
            _buildOption(
              context,
              Icons.lock_reset_rounded,
              "Cambiar Contraseña",
              "Protege tu cuenta con una clave nueva",
              onTap: () => _showChangePasswordDialog(context),
            ),
            const Divider(height: 1, color: Color(0xFFF1F3F5), indent: 70),
            _buildOption(
              context,
              Icons.devices_rounded,
              "Dispositivos vinculados",
              "Gestiona tus sesiones activas",
              onTap: () => _showDevicesList(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    // Estados locales para la visibilidad de cada contraseña
    bool obscureCurrent = true;
    bool obscureNew = true;
    bool obscureConfirm = true;

    showDialog(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final state = ref.watch(changePasswordNotifierProvider);

            return StatefulBuilder(
              builder: (context, setStateDialog) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  contentPadding: EdgeInsets.zero,
                  content: Container(
                    width: 450,
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.security_update_good_rounded,
                          size: 50,
                          color: Color(0xFFC62828),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Actualizar Seguridad",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 24),

                        _buildDialogField(
                          "Contraseña Actual",
                          Icons.lock_outline,
                          controller: _currentPasswordController,
                          obscureText: obscureCurrent,
                          onToggle: () => setStateDialog(() => obscureCurrent = !obscureCurrent),
                        ),
                        const SizedBox(height: 16),
                        _buildDialogField(
                          "Nueva Contraseña",
                          Icons.lock_reset,
                          controller: _newPasswordController,
                          obscureText: obscureNew,
                          onToggle: () => setStateDialog(() => obscureNew = !obscureNew),
                        ),
                        const SizedBox(height: 16),
                        _buildDialogField(
                          "Confirmar Nueva Contraseña",
                          Icons.verified_user_outlined,
                          controller: _confirmPasswordController,
                          obscureText: obscureConfirm,
                          onToggle: () => setStateDialog(() => obscureConfirm = !obscureConfirm),
                        ),

                        const SizedBox(height: 20),

                        Theme(
                          data: ThemeData(unselectedWidgetColor: const Color(0xFFC62828)),
                          child: CheckboxListTile(
                            activeColor: const Color(0xFFC62828),
                            contentPadding: EdgeInsets.zero,
                            title: const Text(
                              "Cerrar sesión en otros dispositivos",
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                            value: _logoutOthers,
                            onChanged: (value) {
                              setStateDialog(() {
                                _logoutOthers = value!;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ),

                        const SizedBox(height: 32),

                        HoverButton(
                          label: state.status == ChangePasswordStatus.loading
                              ? "Cargando..."
                              : "CAMBIAR CONTRASEÑA",
                          baseColor: const Color(0xFFC62828),
                          hoverColor: const Color(0xFFB71C1C),
                          onTap: state.status == ChangePasswordStatus.loading
                              ? null
                              : () {
                                  final current = _currentPasswordController.text.trim();
                                  final newPass = _newPasswordController.text.trim();
                                  final confirm = _confirmPasswordController.text.trim();

                                  if (newPass != confirm) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Las contraseñas no coinciden")),
                                    );
                                    return;
                                  }

                                  if (newPass.length < 8) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Mínimo 8 caracteres")),
                                    );
                                    return;
                                  }

                                  ref.read(changePasswordNotifierProvider.notifier)
                                      .changePassword(
                                        currentPassword: current,
                                        newPassword: newPass,
                                        logoutOthers: _logoutOthers
                                      );
                                },
                        ),

                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildDialogField(
    String label,
    IconData icon, {
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggle,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 13),
        prefixIcon: Icon(icon, color: const Color(0xFFC62828), size: 20),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: Colors.grey,
            size: 18,
          ),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildOption(
    BuildContext context,
    IconData icon,
    String title,
    String sub, {
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFC62828).withOpacity(0.08),
                child: Icon(icon, color: const Color(0xFFC62828), size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  void _showDevicesList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Sesiones Activas", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            _deviceTile(Icons.computer, "MacBook Pro 14\"", "Activo ahora • Hermosillo, MX"),
            _deviceTile(Icons.phone_iphone, "iPhone 15 Pro", "Hace 2 horas • Hermosillo, MX"),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _deviceTile(IconData icon, String title, String sub) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFC62828)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text(sub, style: const TextStyle(fontSize: 12)),
      trailing: TextButton(
        onPressed: () {},
        child: const Text("Cerrar", style: TextStyle(color: Colors.red)),
      ),
    );
  }
}