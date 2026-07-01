import '../../../domain/entities/pending_component_entity_v.dart';

class PendingComponentState {
  final bool isLoading;
  final List<PendingComponentEntityV> data;
  final String? error;

  const PendingComponentState({
    this.isLoading = false,
    this.data = const [],
    this.error,
  });

  PendingComponentState copyWith({
    bool? isLoading,
    List<PendingComponentEntityV>? data,
    String? error,
  }) {
    return PendingComponentState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error,
    );
  }
}