import 'package:crv_reprosisa/features/activos/domain/usecases/get_all_types.dart';
import 'package:crv_reprosisa/features/activos/presentation/providers/type_usecase_provider.dart';
import 'package:crv_reprosisa/features/activos/presentation/states/status.dart';
import 'package:crv_reprosisa/features/activos/presentation/states/type_list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TypeListNotifier extends Notifier<TypeListState> {
  late final GetAllTypes _getAllTypes;

  @override
  TypeListState build() {
    _getAllTypes = ref.read(getAllTypesUseCaseProvider);
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
