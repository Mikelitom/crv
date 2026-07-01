import '../../../domain/entities/incidence_entity.dart';
import '../../../../assets/presentation/states/status.dart';

class IncidenceStateG {
  final Status status;
  final List<IncidenceEntity> incidences;
  final String? error;

  const IncidenceStateG({
    this.status = Status.initial,
    this.incidences = const [],
    this.error,
  });

  IncidenceStateG copyWith({Status? status, List<IncidenceEntity>? incidences, String? error}) {
    return IncidenceStateG(
      status: status ?? this.status,
      incidences: incidences ?? this.incidences,
      error: error ?? this.error,
    );
  }
}