import 'package:crv_reprosisa/features/assets/domain/usecases/get_all_types.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/type_usecase_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/type_list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TypeListNotifier extends Notifier<TypeListState> {
  late final GetAllTypes _getAllTypes;

  @override
  TypeListState build() {
    _getAllTypes = ref.read(getAllTypesUseCaseProvider);

    Future.microtask(() => loadTypes());

    return const TypeListState();
  }

  Future<void> loadTypes() async {
    state = state.copyWith(status: Status.loading);
    print("Loading vehicle types...");
    final result = await _getAllTypes();

    result.fold(
      (failure) {
        state = state.copyWith(status: Status.error, error: failure.message);
      },
      (types) {
        state = state.copyWith(status: Status.success, types: types);
      },
    );
  }
}
