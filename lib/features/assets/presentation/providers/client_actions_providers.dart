import 'package:flutter_riverpod/flutter_riverpod.dart';

// Importaciones de Notifiers
import 'package:crv_reprosisa/features/assets/presentation/notifiers/activate_client_notifier.dart';
import 'package:crv_reprosisa/features/assets/presentation/notifiers/delete_client_notifier.dart';
import 'package:crv_reprosisa/features/assets/presentation/notifiers/activate_mine_notifier.dart';
import 'package:crv_reprosisa/features/assets/presentation/notifiers/delete_mine_notifier.dart';
import 'package:crv_reprosisa/features/assets/presentation/notifiers/create_mine_notifier.dart'; // Import para crear mina

// Importaciones de estados
import 'package:crv_reprosisa/features/assets/presentation/states/client_state.dart';

/// Providers para acciones de Clientes
final activateClientProvider = NotifierProvider<ActivateClientNotifier, ClientState>(
  ActivateClientNotifier.new,
);

final deleteClientProvider = NotifierProvider<DeleteClientNotifier, ClientState>(
  DeleteClientNotifier.new,
);

/// Providers para acciones de Minas
final activateMineProvider = NotifierProvider<ActivateMineNotifier, ClientState>(
  ActivateMineNotifier.new,
);

final deleteMineProvider = NotifierProvider<DeleteMineNotifier, ClientState>(
  DeleteMineNotifier.new,
);

/// Provider para creación de nuevas minas a un cliente
final createMineProvider = NotifierProvider<CreateMineNotifier, ClientState>(
  CreateMineNotifier.new,
);