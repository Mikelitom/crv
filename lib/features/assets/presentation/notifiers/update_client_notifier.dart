import 'package:crv_reprosisa/features/assets/domain/params/create_clients_params.dart';
import 'package:crv_reprosisa/features/assets/domain/usecases/update_client.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/client_usecase_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/client_state.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateClientNotifier extends Notifier<ClientState> {
  late final UpdateClient _updateClient;

  @override
  ClientState build() {
    _updateClient = ref.read(updateClientUseCaseProvider);
    return const ClientState(status: Status.initial);
  }

  Future<void> update(String id, CreateClientParams params) async {
    state = state.copyWith(
      status: Status.loading,
      clearError: true,
      clearMessage: true,
    );

    try {
      final result = await _updateClient(id, params);

      result.fold(
        (failure) {
          state = state.copyWith(status: Status.error, error: failure.message);
        },
        (_) {
          state = state.copyWith(
            status: Status.success,
            message: "Cliente actualizado correctamente",
          );
        },
      );
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;

      if (statusCode == 409) {
        state = state.copyWith(
          status: Status.error,
          error: data?['detail'] ?? "Ya existe un registro con ese correo",
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
