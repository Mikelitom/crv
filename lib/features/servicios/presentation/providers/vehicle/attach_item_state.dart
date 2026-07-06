// lib/features/servicios/presentation/states/attach_items_state.dart
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';

class AttachItemsState {
  final Status status;
  final String? error;

  const AttachItemsState({this.status = Status.initial, this.error});

  AttachItemsState copyWith({Status? status, String? error}) {
    return AttachItemsState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}