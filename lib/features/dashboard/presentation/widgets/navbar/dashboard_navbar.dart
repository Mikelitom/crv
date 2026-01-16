import 'package:flutter/material.dart';

class DashboardNavbar extends StatelessWidget {
  final String userName;
  final String userRole;
  final bool isDesktop;

  const DashboardNavbar({
    super.key,
    required this.userName,
    required this.userRole,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          // BOTÓN DE MENÚ: Aparece solo si NO es escritorio
          if (!isDesktop)
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.black87),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),

          if (!isDesktop) const SizedBox(width: 8),

          // TÍTULO (Ocultar subtítulo en pantallas muy pequeñas)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Panel de Control',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              if (width > 500)
                const Text(
                  'Sistema CRV - Gestión Industrial',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
            ],
          ),

          const Spacer(),

          // BUSCADOR: Solo se muestra si hay espacio suficiente (> 700px)
          if (width > 700)
            Expanded(
              flex: 3,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Buscar...",
                    prefixIcon: Icon(Icons.search, size: 20),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 5),
                  ),
                ),
              ),
            ),

          const Spacer(),

          // PERFIL Y NOTIFICACIONES
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
          
          const SizedBox(width: 8),

          // El nombre solo se ve en pantallas medianas/grandes
          if (width > 600)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text(userRole, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),

          const SizedBox(width: 10),
          
          const CircleAvatar(
            backgroundColor: Color(0xFFC62828),
            radius: 18,
            child: Icon(Icons.person, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}