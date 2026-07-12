import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';

class VehicleState {
  final Status status;
  final String? error;
  final String? message;

  const VehicleState({
    this.status = Status.initial,
    this.error,
    this.message,
  });

  VehicleState copyWith({
    Status? status,
    String? error,
    String? message,
    bool clearError = false,
    bool clearMessage = false,
  }) {
    return VehicleState(
      status: status ?? this.status,
      error: clearError ? null : (error ?? this.error),
      message: clearMessage ? null : (message ?? this.message),
    );
  }
}