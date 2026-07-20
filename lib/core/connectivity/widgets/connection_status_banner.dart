import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/connection_provider.dart';

class ConnectionStatusBanner extends ConsumerWidget {
  const ConnectionStatusBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final connection = ref.watch(connectionProvider);


    if (connection.isSyncing) {
      return _ConnectionBanner(
        icon: Icons.sync,
        title: 'Sincronizando',

        message: connection.pendingReports > 0
            ? 'Enviando ${connection.pendingReports} reportes pendientes...'
            : 'Enviando reportes pendientes...',
        
        type: BannerType.syncing,
      );
    }


    if (!connection.isConnected) {
      return _ConnectionBanner(
        icon: Icons.cloud_off,
        title: 'Modo offline',

        message: connection.pendingReports > 0
            ? 'Puedes continuar trabajando. '
              '${connection.pendingReports} reportes pendientes de sincronizar.'
            : 'Puedes crear reportes. '
              'Las imágenes deberán agregarse cuando vuelva la conexión.',

        type: BannerType.offline,
      );
    }


    return const SizedBox.shrink();
  }
}


enum BannerType {
  offline,
  syncing,
}


class _ConnectionBanner extends StatelessWidget {

  final IconData icon;
  final String title;
  final String message;
  final BannerType type;


  const _ConnectionBanner({
    required this.icon,
    required this.title,
    required this.message,
    required this.type,
  });


  @override
  Widget build(BuildContext context) {

    final isSyncing = type == BannerType.syncing;


    return Container(
      width: double.infinity,

      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: isSyncing
            ? Colors.blue.shade50
            : Colors.orange.shade50,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(
          color: isSyncing
              ? Colors.blue.shade200
              : Colors.orange.shade200,
        ),
      ),

      child: Row(
        children: [

          Icon(
            icon,
            size: 28,
            color: isSyncing
                ? Colors.blue.shade800
                : Colors.orange.shade800,
          ),


          const SizedBox(width: 12),


          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),


                const SizedBox(height: 3),


                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }
}