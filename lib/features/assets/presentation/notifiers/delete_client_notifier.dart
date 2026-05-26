// lib/features/assets/presentation/notifiers/delete_client_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/client_usecase_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/client_state.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';

class DeleteClientNotifier extends Notifier<ClientState> {
  @override
  ClientState build() => const ClientState(status: Status.initial);

  Future<void> delete(String id) async {
    state = state.copyWith(status: Status.loading);
    final result = await ref.read(deleteClientUseCaseProvider).call(id);
    result.fold(
      (f) => state = state.copyWith(status: Status.error, error: f.message),
      (_) => state = state.copyWith(status: Status.success, message: "Cliente eliminado"),
    );
  }
}