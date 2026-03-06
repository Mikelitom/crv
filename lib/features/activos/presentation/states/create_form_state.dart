enum FormStatus { initial, loading, success, error }

class FormState<T> {
  final FormStatus status;
  final T? data;
  final String? error;

  const FormState({required this.status, this.data, this.error});

  const FormState.initial()
    : status = FormStatus.initial,
      data = null,
      error = null;

  FormState<T> copyWith({FormStatus? status, T? data, String? error}) {
    return FormState(
      status: status ?? this.status,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }
}
