import 'package:crv_reprosisa/core/utils/scope_mapper.dart';
import 'package:crv_reprosisa/features/profile/presentation/provider/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/auth/domain/entities/user.dart';
import 'package:crv_reprosisa/features/profile/presentation/provider/profile_notifier.dart';

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
        final notifier = ref.read(profileProvider.notifier);
        notifier.getUserProfile();
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
    // Escuchamos el estado del perfil
    final profileState = ref.watch(profileProvider);

    ref.listen<ProfileState>(profileProvider, (prev, next) {
      if (next.status == ProfileStatus.success && next.user != null) {
        _nameController.text = next.user!.name;
        _emailController.text = next.user!.email;
        _phoneController.text = next.user!.phone ?? '';
        _areaController.text = mapScope(next.user!.scope);
      }

      if (next.status == ProfileStatus.error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error.toString())));
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      body: _buildBody(profileState),
    );
  }

  Widget _buildBody(ProfileState state) {
    // 1. SI ESTÁ CARGANDO Y NO HAY USUARIO (Carga inicial)
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

    // 2. SI HUBO UN ERROR Y NO HAY DATOS
    if (state.status == ProfileStatus.error && state.user == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text("Error: ${state.error}"),
            TextButton(
              onPressed: () =>
                  ref.read(profileProvider.notifier).getUserProfile(),
              child: const Text("Reintentar"),
            ),
          ],
        ),
      );
    }

    // 3. SI YA TENEMOS AL USUARIO (ÉXITO)
    final user = state.user!;

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
                // Barra de progreso discreta si se está actualizando en segundo plano
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
              ref.read(profileProvider.notifier).updateInfo(_nameController.text, _emailController.text, _phoneController.text);
            },
          ),
        ],
      ),
    );
  }
}
