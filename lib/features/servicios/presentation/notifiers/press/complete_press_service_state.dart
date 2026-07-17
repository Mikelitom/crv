class CompleteServiceState {
  final bool loading;
  final bool success;
  final String? error;

  const CompleteServiceState({
    this.loading = false,
    this.success = false,
    this.error,
  });

  CompleteServiceState copyWith({
    bool? loading,
    bool? success,
    String? error,
  }) {
    return CompleteServiceState(
      loading: loading ?? this.loading,
      success: success ?? this.success,
      error: error,
    );
  }

  factory CompleteServiceState.initial() {
    return const CompleteServiceState();
  }
}