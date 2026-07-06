// lib/features/servicios/presentation/providers/press_incidence_state.dart
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:crv_reprosisa/features/servicios/domain/entities/press_incidence_entity.dart';


class PressIncidenceState {
  final Status status;
  final List<PressIncidenceEntity> incidences;
  final String? error;

  const PressIncidenceState({
    this.status = Status.initial,
    this.incidences = const [],
    this.error,
  });

  PressIncidenceState copyWith({Status? status, List<PressIncidenceEntity>? incidences, String? error}) {
    return PressIncidenceState(
      status: status ?? this.status,
      incidences: incidences ?? this.incidences,
      error: error ?? this.error,
    );
  }
}