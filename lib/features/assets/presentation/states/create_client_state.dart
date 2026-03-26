import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';

class CreateClientState {
  final Status status;
  final String? error;
  final String? message;

  const CreateClientState({
    this.status = Status.initial,
    this.error,
    this.message,
  });

  CreateClientState copyWith({
    Status? status,
    String? error,
    String? message,
    bool clearError = false,
    bool clearMessage = false,
  }) {
    return CreateClientState(
      status: status ?? this.status,
      error: clearError ? null : (error ?? this.error),
      message: clearMessage ? null : (message ?? this.message),
    );
  }
}
