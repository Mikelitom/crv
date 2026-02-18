import 'package:flutter/material.dart';

class DialogCrearUsuario extends StatefulWidget {
  @override
  State<DialogCrearUsuario> createState() => _DialogCrearUsuarioState();
}

class _DialogCrearUsuarioState extends State<DialogCrearUsuario> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Controlador para las animaciones de entrada
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
      child: AlertDialog(
        backgroundColor: Colors.white.withOpacity(0.95), // Efecto cristal suave
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        title: _buildHeader(),
        content: SizedBox(
          width: 600,
          child: LayoutBuilder(builder: (context, constraints) {
            double inputWidth = constraints.maxWidth > 500 ? 270 : constraints.maxWidth;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Wrap(
                spacing: 20,
                runSpacing: 25,
                children: [
                  _animatedItem(0, _buildInput("Nombre Completo *", "Ej. Carlos Ramírez", inputWidth, Icons.person_outline)),
                  _animatedItem(1, _buildInput("Email Institucional *", "usuario@reprosisa.com", inputWidth, Icons.alternate_email)),
                  _animatedItem(2, _buildInput("Teléfono", "+52 444...", inputWidth, Icons.phone_android_outlined)),
                  _animatedItem(3, _buildInput("Contraseña Temporal *", "••••••••", inputWidth, Icons.lock_outline, obscure: true)),
                  _animatedItem(4, _buildDropdown("Rol del Sistema", ["Administrador", "Empleado"], inputWidth, Icons.admin_panel_settings_outlined)),
                  _animatedItem(5, _buildDropdown("Área Asignada", ["Vehículos", "Prensas", "Bandas"], inputWidth, Icons.category_outlined)),
                ],
              ),
            );
          }),
        ),
        actionsPadding: const EdgeInsets.all(24),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFD32F2F).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.person_add_rounded, color: Color(0xFFD32F2F), size: 32),
        ),
        const SizedBox(height: 16),
        const Text(
          "Registrar Nuevo Usuario",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: Color(0xFF1A1C1E)),
        ),
        const Text(
          "Completa los datos para el nuevo acceso",
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ],
    );
  }

  // Widget para manejar la animación de cascada por cada item
  Widget _animatedItem(int index, Widget child) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _controller,
        curve: Interval(0.1 * index, 1.0, curve: Curves.easeIn),
      ),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(parent: _controller, curve: Interval(0.1 * index, 1.0, curve: Curves.easeOut)),
        ),
        child: child,
      ),
    );
  }

  Widget _buildInput(String label, String hint, double width, IconData icon, {bool obscure = false}) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFFC62828))),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: TextField(
              obscureText: obscure,
              decoration: InputDecoration(
                prefixIcon: Icon(icon, color: Colors.grey, size: 20),
                hintText: hint,
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 2)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, double width, IconData icon) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFFC62828))),
          ),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.grey, size: 20),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 2)),
            ),
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (v) {},
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(colors: [Color(0xFFD32F2F), Color(0xFFB71C1C)]), // Gradiente de acción
        boxShadow: [BoxShadow(color: const Color(0xFFD32F2F).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: const Text("Crear Usuario", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}