import 'package:flutter/material.dart';
import 'hover_button.dart';

class ProfileSecurityCard extends StatefulWidget {
  const ProfileSecurityCard({super.key});

  @override
  State<ProfileSecurityCard> createState() => _ProfileSecurityCardState();
}

class _ProfileSecurityCardState extends State<ProfileSecurityCard> {
  bool _logoutOthers = false; // Estado para el checkbox estilo Facebook

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 25, offset: const Offset(0, 10)),
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
    // Usamos un StatefulBuilder para que el Checkbox se pueda marcar dentro del Dialog
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
              contentPadding: EdgeInsets.zero,
              content: Container(
                width: 450,
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.security_update_good_rounded, size: 50, color: Color(0xFFC62828)),
                    const SizedBox(height: 16),
                    const Text("Actualizar Seguridad", 
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 24),
                    
                    _buildDialogField("Contraseña Actual", Icons.lock_outline),
                    const SizedBox(height: 16),
                    _buildDialogField("Nueva Contraseña", Icons.lock_reset),
                    const SizedBox(height: 16),
                    _buildDialogField("Confirmar Nueva Contraseña", Icons.verified_user_outlined),
                    
                    const SizedBox(height: 20),
                    
                    // OPCIÓN ESTILO FACEBOOK
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
                      controlAffinity: ListTileControlAffinity.leading,                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    HoverButton(
                      label: "CAMBIAR CONTRASEÑA",
                      baseColor: const Color(0xFFC62828),
                      hoverColor: const Color(0xFFB71C1C),
                      onTap: () {
                        // Aquí iría tu lógica de validación y API
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Contraseña actualizada con éxito"))
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
  }

  Widget _buildDialogField(String label, IconData icon) {
    return TextFormField(
      obscureText: true,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 13),
        prefixIcon: Icon(icon, color: const Color(0xFFC62828), size: 20),
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildOption(BuildContext context, IconData icon, String title, String sub, {required VoidCallback onTap}) {
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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
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
      trailing: TextButton(onPressed: () {}, child: const Text("Cerrar", style: TextStyle(color: Colors.red))),
    );
  }
}