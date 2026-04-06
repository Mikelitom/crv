import 'package:crv_reprosisa/features/assets/presentation/notifiers/create_client_notifier.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/client_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createClientProvider =
    NotifierProvider<CreateClientNotifier, ClientState>(
      CreateClientNotifier.new,
    );
