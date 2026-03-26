import 'package:crv_reprosisa/features/assets/presentation/notifiers/client_list_notifier.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/clients_list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final clientListProvider =
    NotifierProvider<ClientListNotifier, ClientsListState>(
      ClientListNotifier.new,
    );
