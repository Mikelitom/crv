import 'package:crv_reprosisa/features/activos/domain/entities/clients_conveyor.dart';

import 'status.dart';

class ClientsListState {
  final Status status;
  final List<ClientsConveyor> clients;
  final String? error;

  const ClientsListState({
    this.status = Status.initial,
    this.clients = const [],
    this.error,
  });

  ClientsListState copyWith({
    Status? status,
    List<ClientsConveyor>? clients,
    String? error,
  }) {
    return ClientsListState(
      status: status ?? this.status,
      clients: clients ?? this.clients,
      error: error,
    );
  }
}
