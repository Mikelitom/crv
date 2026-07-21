import 'package:flutter/foundation.dart';

@immutable
class ReportsState {
  final List<dynamic> allReports; // Lista completa cruda de la API
  final List<dynamic>
  filteredReports; // Lista que se muestra en la UI tras filtrar
  final bool isLoading;
  final String? errorMessage;
  final int activeTabIndex;
  final List<dynamic> pendingReports;

  const ReportsState({
    this.allReports = const [],
    this.filteredReports = const [],
    this.isLoading = false,
    this.errorMessage,
    this.activeTabIndex = 0,
    this.pendingReports = const []
  });

  /// Factory inicial para cuando la app arranca
  factory ReportsState.initial() => const ReportsState();

  ReportsState copyWith({
    List<dynamic>? allReports,
    List<dynamic>? filteredReports,
    bool? isLoading,
    String? errorMessage,
    int? activeTabIndex,
    List<dynamic>? pendingReports,
  }) {
    return ReportsState(
      allReports: allReports ?? this.allReports,
      filteredReports: filteredReports ?? this.filteredReports,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
      pendingReports: pendingReports ?? this.pendingReports
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReportsState &&
        other.allReports == allReports &&
        other.filteredReports == filteredReports &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage &&
        other.activeTabIndex == activeTabIndex;
  }

  @override
  int get hashCode {
    return allReports.hashCode ^
        filteredReports.hashCode ^
        isLoading.hashCode ^
        errorMessage.hashCode ^
        activeTabIndex.hashCode;
  }
}
