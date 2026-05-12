import 'package:crv_reprosisa/features/assets/domain/entities/clients.dart';

import 'status.dart';

class ClientsListState {
  final Status status;
  final List<Clients> clients;
  final String? error;

  const ClientsListState({
    this.status = Status.initial,
    this.clients = const [],
    this.error,
  });

  ClientsListState copyWith({
    Status? status,
    List<Clients>? clients,
    String? error,
  }) {
    return ClientsListState(
      status: status ?? this.status,
      clients: clients ?? this.clients,
      error: error,
    );
  }
}
