import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';

class ClientState {
  final Status status;
  final String? error;
  final String? message;

  const ClientState({
    this.status = Status.initial,
    this.error,
    this.message,
  });

  ClientState copyWith({
    Status? status,
    String? error,
    String? message,
    bool clearError = false,
    bool clearMessage = false,
  }) {
    return ClientState(
      status: status ?? this.status,
      error: clearError ? null : (error ?? this.error),
      message: clearMessage ? null : (message ?? this.message),
    );
  }
}
