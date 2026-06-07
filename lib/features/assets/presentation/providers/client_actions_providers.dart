import 'package:flutter_riverpod/flutter_riverpod.dart';

// Importaciones de 
import 'package:crv_reprosisa/features/assets/presentation/notifiers/activate_client_notifier.dart';
import 'package:crv_reprosisa/features/assets/presentation/notifiers/delete_client_notifier.dart';
import 'package:crv_reprosisa/features/assets/presentation/notifiers/activate_mine_notifier.dart';
import 'package:crv_reprosisa/features/assets/presentation/notifiers/delete_mine_notifier.dart';
import 'package:crv_reprosisa/features/assets/presentation/notifiers/create_mine_notifier.dart'; // Import para crear mina
import '../notifiers/client_history_notifier.dart';
import '../notifiers/conveyor_report_detail_notifier.dart';
import '../states/client_history_state.dart';
import '../states/conveyor_report_detail_state.dart';

import 'package:crv_reprosisa/features/assets/presentation/states/client_state.dart';

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
final clientHistoryProvider = NotifierProvider<ClientHistoryNotifier, ClientHistoryState>(
  ClientHistoryNotifier.new,
);

final conveyorReportDetailProvider = NotifierProvider<ConveyorReportDetailNotifier, ConveyorReportDetailState>(
  ConveyorReportDetailNotifier.new,
);