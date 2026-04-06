import 'package:crv_reprosisa/features/assets/domain/params/create_press_params.dart';
import 'package:crv_reprosisa/features/assets/domain/usecases/update_press.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/press_usecase_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/press_state.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdatePressNotifier extends Notifier<PressState> {
  late final UpdatePress _updatePress;

  @override
  PressState build() {
    _updatePress = ref.read(updatePressUseCaseProvider);
    return const PressState(status: Status.initial);
  }

  Future<void> update(String id, CreatePressParams params) async {
    state = state.copyWith(
      status: Status.loading,
      clearError: true,
      clearMessage: true,
    );

    try {
      final result = await _updatePress(id, params);

      result.fold(
        (failure) {
          state = state.copyWith(status: Status.error, error: failure.message);
        },
        (_) {
          state = state.copyWith(
            status: Status.success,
            message: "Prensa actualizada correctamente",
          );
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
      state = state.copyWith(
        status: Status.error,
        error: "Error inesperado. Intenta de nuevo.",
      );
    }
  }
}
