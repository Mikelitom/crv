import 'package:crv_reprosisa/core/error/failure.dart';

enum ChangePasswordStatus { initial, loading, success, error }

class ChangePasswordState {
  final ChangePasswordStatus status;
  final Failure? failure;

  const ChangePasswordState({
    required this.status,
    this.failure,
  });

  factory ChangePasswordState.initial() =>
      const ChangePasswordState(status: ChangePasswordStatus.initial);

  ChangePasswordState copyWith({
    ChangePasswordStatus? status,
    Failure? failure,
  }) {
    return ChangePasswordState(
      status: status ?? this.status,
      failure: failure,
    );
  }
}
