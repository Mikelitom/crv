import '../../domain/entities/client_history.dart';
import '../../domain/entities/conveyor_report_detail.dart';
import 'status.dart';

class ClientHistoryState {
  final Status status;
  final List<ClientHistory> history;
  final ConveyorReportDetail? detail; 
  final String? error;

  const ClientHistoryState({
    this.status = Status.initial,
    this.history = const [],
    this.detail,
    this.error,
  });

  ClientHistoryState copyWith({
    Status? status,
    List<ClientHistory>? history,
    ConveyorReportDetail? detail,
    String? error,
  }) {
    return ClientHistoryState(
      status: status ?? this.status,
      history: history ?? this.history,
      detail: detail ?? this.detail,
      error: error,
    );
  }
}