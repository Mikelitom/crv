import 'package:crv_reprosisa/core/utils/scope_mapper.dart';
import 'package:crv_reprosisa/features/profile/presentation/provider/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/auth/domain/entities/user.dart';
import 'package:crv_reprosisa/features/profile/presentation/provider/profile_notifier.dart';
import 'package:crv_reprosisa/features/auth/presentation/providers/auth_notifier_provider.dart'; // 👈 Importante

import '../widgets/history_status_panel.dart';
import '../widgets/profile_security_card.dart';
import '../widgets/profile_form_field.dart';
import '../widgets/hover_button.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _areaController;

  @override
  void initState() {
    Future.microtask(() {
      ref.read(profileProvider.notifier).getUserProfile();
    });

    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _areaController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    ref.listen<ProfileState>(profileProvider, (prev, next) {
      if (next.status == ProfileStatus.success && next.user != null) {
        _nameController.text = next.user!.name;
        _emailController.text = next.user!.email;
        _phoneController.text = next.user!.phone ?? '';
        _areaController.text = mapScope(next.user!.scope);
      }

      if (next.status == ProfileStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString())),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      // 👈 Añadimos un AppBar para que el usuario pueda desloguearse si está bloqueado
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Mi Perfil", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Color(0xFFC62828)),
            onPressed: () => ref.read(authNotifierProvider.notifier).logout(),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: _buildBody(profileState),
    );
  }

  Widget _buildBody(ProfileState state) {
    if (state.status == ProfileStatus.loading && state.user == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFFC62828)),
            SizedBox(height: 16),
            Text("Cargando perfil...", style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    if (state.status == ProfileStatus.error && state.user == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text("Error: ${state.error}"),
            TextButton(
              onPressed: () => ref.read(profileProvider.notifier).getUserProfile(),
              child: const Text("Reintentar"),
            ),
          ],
        ),
      );
    }

    final user = state.user!;
    final bool isNotVerified = !user.isVerified; // 👈 Usamos el getter de tu Entidad

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth > 1100;

        return SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 40 : 20,
              vertical: 20,
            ),
            child: Column(
              children: [
                // 👈 BANNER DE APROBACIÓN PENDIENTE
                if (isNotVerified) _buildVerificationBanner(),

                if (state.status == ProfileStatus.loading)
                  const LinearProgressIndicator(
                    color: Color(0xFFC62828),
                    minHeight: 2,
                  ),

                const SizedBox(height: 10),

                if (isDesktop)
                  _buildDesktopLayout(context, user)
                else
                  _buildMobileLayout(context, user),
              ],
            ),
          ),
        );
      },
    );
  }

  // 👈 Widget del Banner informativo
  Widget _buildVerificationBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.orange.shade300),
      ),
      child: Column(
        children: [
          const Icon(Icons.pending_actions_rounded, color: Colors.orange, size: 40),
          const SizedBox(height: 12),
          const Text(
            "SOLICITUD EN PROCESO",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            "Tu cuenta ha sido creada exitosamente. Un administrador debe asignarte un área para habilitar las inspecciones.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          // Botón para que el usuario actualice sin salir
          TextButton.icon(
            onPressed: () => ref.read(profileProvider.notifier).getUserProfile(),
            icon: const Icon(Icons.refresh_rounded, color: Colors.orange),
            label: const Text("ACTUALIZAR ESTADO", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, User user) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            children: [
              _buildMainInfoPanel(user),
              const SizedBox(height: 24),
              const ProfileSecurityCard(),
            ],
          ),
        ),
        const SizedBox(width: 40),
        Expanded(
          flex: 2,
          child: Column(children: [HistoryStatusPanel(user: user)]),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, User user) {
    return Column(
      children: [
        HistoryStatusPanel(user: user),
        const SizedBox(height: 24),
        _buildMainInfoPanel(user),
        const SizedBox(height: 24),
        const ProfileSecurityCard(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildMainInfoPanel(User user) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 35,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Información Personal",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          ProfileFormField(
            label: "Nombre Completo",
            controller: _nameController,
            icon: Icons.person_outline,
          ),
          ProfileFormField(
            label: "Correo Institucional",
            controller: _emailController,
            icon: Icons.email_outlined,
          ),
          ProfileFormField(
            label: "Teléfono",
            controller: _phoneController,
            icon: Icons.phone_android_outlined,
          ),
          ProfileFormField(
            label: "Departamento",
            enabled: false,
            controller: _areaController,
            icon: Icons.business_outlined,
          ),
          const SizedBox(height: 12),
          HoverButton(
            label: "GUARDAR CAMBIOS",
            baseColor: const Color(0xFFC62828),
            hoverColor: const Color.fromARGB(255, 169, 18, 18),
            onTap: () {
              ref.read(profileProvider.notifier).updateInfo(
                _nameController.text, 
                _emailController.text, 
                _phoneController.text
              );
            },
          ),
        ],
      ),
    );
  }
}