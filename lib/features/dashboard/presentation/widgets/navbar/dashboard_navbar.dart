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
          // BOTÓN DE MENÚ: Aparece solo si NO es escritorio (móvil/tablet)
          if (!isDesktop)
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.black87),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),

          if (!isDesktop) const SizedBox(width: 8),

          // TÍTULO O MARCA DEL SISTEMA
          const Text(
            "REPROSISA",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFC62828),
              letterSpacing: 1.2,
            ),
          ),

          const Spacer(),

          // NOTIFICACIONES
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black87),
            onPressed: () {},
          ),
          
          const SizedBox(width: 8),

          // INFORMACIÓN DEL USUARIO
          if (width > 600)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  userRole,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

          const SizedBox(width: 10),
          
          // AVATAR
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