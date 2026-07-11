import 'package:crv_reprosisa/features/servicios/presentation/providers/last_move_providers.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/last_movement_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardNotifier extends Notifier<DashboardState> {

  @override
  DashboardState build() {
    Future.microtask(loadLastMovements);

    return const DashboardState();
  }

  Future<void> loadLastMovements() async {
    state = state.copyWith(isLoading: true);

    try {
      final response =
          await ref.read(getLastMovementsUseCaseProvider)();

      state = state.copyWith(
        isLoading: false,
        vehicleMovements: response.vehicles,
        pressMovements: response.presses,
      );
    } catch (e, stackTrace) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: stackTrace);

      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> refresh() async {
    await loadLastMovements();
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }
}