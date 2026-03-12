import 'package:crv_reprosisa/features/activos/domain/usecases/get_all_press.dart';
import 'package:crv_reprosisa/features/activos/presentation/providers/press_usecase_provider.dart';
import 'package:crv_reprosisa/features/activos/presentation/states/press_list_state.dart';
import 'package:crv_reprosisa/features/activos/presentation/states/status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PressListNotifier extends Notifier<PressListState> {
  late final GetAllPress _getAllPress;

  @override
  PressListState build() {
    _getAllPress = ref.read(getAllPressUseCaseProvider);
    return const PressListState();
  }

  Future<void> loadPress() async {
    state = state.copyWith(status: Status.loading);

    final result = await _getAllPress();

    result.fold(
      (failure) {
        state = state.copyWith(status: Status.error, error: failure.message);
      },
      (press) {
        state = state.copyWith(status: Status.success, press: press);
      },
    );
  }
}
