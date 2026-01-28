import 'package:flutter/material.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/history_status_panel.dart';
import '../widgets/profile_security_card.dart';
import '../widgets/profile_form_field.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth > 1100;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                if (isDesktop) _buildDesktopLayout() else _buildMobileLayout(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Columna Izquierda: Formulario Extendido
        Expanded(
          flex: 3,
          child: Column(
            children: [
              _buildMainInfoPanel(),
              const SizedBox(height: 24),
              const ProfileSecurityCard(),
            ],
          ),
        ),
        const SizedBox(width: 40),
        // Columna Derecha: Avatar y Estatus
        Expanded(
          flex: 2,
          child: Column(
            children: [
              const ProfileAvatar(),
              const SizedBox(height: 32),
              const HistoryStatusPanel(),
              const SizedBox(height: 24),
              const _HoverButton(
                label: "CERRAR SESIÓN",
                baseColor: Color(0xFFC62828),
                hoverColor: Color(0xFFB71C1C),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainInfoPanel() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 35, offset: const Offset(0, 15))
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Información Personal", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 32),
          ProfileFormField(label: "Nombre Completo", initialValue: "Juan Pérez García", icon: Icons.person_outline),
          ProfileFormField(label: "Correo Institucional", initialValue: "j.perez@empresa.com", icon: Icons.email_outlined),
          ProfileFormField(label: "Teléfono", initialValue: "+52 662 123 4567", icon: Icons.phone_android_outlined),
          ProfileFormField(label: "Departamento", initialValue: "Sistemas / Flota", icon: Icons.business_outlined),
          ProfileFormField(label: "Ubicación", initialValue: "Planta Hermosillo", icon: Icons.location_on_outlined),
          SizedBox(height: 12),
          _HoverButton(
            label: "GUARDAR CAMBIOS",
            baseColor: Color(0xFFC62828),
            hoverColor: Color.fromARGB(255, 169, 18, 18), // Cambia a verde al pasar el cursor para "Guardar"
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return const Column(
      children: [
        ProfileAvatar(),
        SizedBox(height: 32),
        HistoryStatusPanel(),
        SizedBox(height: 24),
        ProfileSecurityCard(),
      ],
    );
  }
}

// WIDGET INTERNO: Botón con efecto Hover
class _HoverButton extends StatefulWidget {
  final String label;
  final Color baseColor;
  final Color hoverColor;

  const _HoverButton({required this.label, required this.baseColor, required this.hoverColor});

  @override
  State<_HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<_HoverButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          color: _isHovered ? widget.hoverColor : widget.baseColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: (_isHovered ? widget.hoverColor : widget.baseColor).withOpacity(0.3),
              blurRadius: _isHovered ? 20 : 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: Text(widget.label, 
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          ),
        ),
      ),
    );
  }
}