import 'package:crv_reprosisa/features/activos/domain/params/create_press_params.dart';
import 'package:crv_reprosisa/features/activos/domain/usecases/create_press.dart';
import 'package:crv_reprosisa/features/activos/presentation/providers/press_usecase_provider.dart';
import 'package:crv_reprosisa/features/activos/presentation/states/create_press_state.dart';
import 'package:crv_reprosisa/features/activos/presentation/states/status.dart';
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

    final result = await _createPress(params);

    result.fold(
      (failure) {
        state = state.copyWith(status: Status.error, error: failure.message);
      },
      (_) {
        state = state.copyWith(status: Status.success);
      },
    );
  }
}
