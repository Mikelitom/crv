// lib/features/assets/presentation/states/press_history_state.dart
import 'package:crv_reprosisa/features/assets/domain/entities/press_history.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';

class PressHistoryState {
  final Status status;
  final List<PressHistory> history;
  final String error;

  const PressHistoryState({
    this.status = Status.initial,
    this.history = const [],
    this.error = '',
  });

  PressHistoryState copyWith({
    Status? status,
    List<PressHistory>? history,
    String? error,
  }) {
    return PressHistoryState(
      status: status ?? this.status,
      history: history ?? this.history,
      error: error ?? this.error,
    );
  }
}