import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/assets/presentation/notifiers/client_history_notifier.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/client_history_state.dart';

/// Este provider sustituye al antiguo conveyorHistoryProvider
final clientHistoryProvider = NotifierProvider<ClientHistoryNotifier, ClientHistoryState>(
  ClientHistoryNotifier.new,
);