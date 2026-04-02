import 'package:crv_reprosisa/features/assets/domain/params/create_press_params.dart';
import 'package:crv_reprosisa/features/assets/domain/usecases/create_press.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/press_usecase_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/create_press_state.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreatePressNotifier extends Notifier<CreatePressState> {
  late final CreatePress _createPress;

  @override
  CreatePressState build() {
    _createPress = ref.read(createPressUseCaseProvider);
    return const CreatePressState();
  }

  Future<void> create(CreatePressParams params) async {
    state = state.copyWith(status: Status.loading);

    try {
      final result = await _createPress(params);

      result.fold(
        (failure) {
          state = state.copyWith(status: Status.error, error: failure.message);
        },
        (_) {
          state = state.copyWith(status: Status.success);
        },
      );
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;

      if (statusCode == 409) {
        state = state.copyWith(
          status: Status.error,
          error:
              data?['detail'] ??
              "Ya existe un registro con ese numero de serie",
        );
      }
      return;
    } catch (e) {
      state = state.copyWith(status: Status.error, error: e.toString());
    }
  }
}
