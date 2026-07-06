import '../../domain/entities/press_item_entity.dart';
import '../../../../features/assets/presentation/states/status.dart';

class PressItemState {
  final Status status;
  final List<PressItemEntity> data;
  final String? error;

  const PressItemState({
    this.status = Status.initial,
    this.data = const [],
    this.error,
  });

  PressItemState copyWith({
    Status? status,
    List<PressItemEntity>? data,
    String? error,
  }) {
    return PressItemState(
      status: status ?? this.status,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }
}