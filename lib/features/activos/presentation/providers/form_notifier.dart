import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:dartz/dartz.dart';

import '../states/create_form_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class FormNotifier<T, P> extends Notifier<FormState<T>> {
  @override
  FormState<T> build() {
    return const FormState.initial();
  }

  Future<void> submit(Future<Either<Failure, T>> Function() action) async {
    state = state.copyWith(status: FormStatus.loading, error: null);

    final result = await action();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: FormStatus.error,
          error: failure.message,
        );
      },
      (data) {
        state = state.copyWith(status: FormStatus.success, data: data);
      },
    );
  }
}
