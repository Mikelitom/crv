import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/inspeccion_state.dart';
import '../provider/inspeccion_providers.dart';
import '../../domain/entities/loan_area.dart';

class InspeccionNotifier extends Notifier<InspeccionState> {
  @override
  InspeccionState build() {
    Future.microtask(() => loadLoanAreas());
    return InspeccionState(inspectionDate: DateTime.now());
  }

  void updateArea(String area) => state = state.copyWith(area: area);

  Future<void> loadLoanAreas() async {
    final useCase = ref.read(getLoanAreasUseCaseProvider);
    final result = await useCase();
    
    result.fold(
      (f) => null,
      (areasList) {
        // CORRECCIÓN: 'areasList' ya es List<LoanArea> gracias al ajuste en el Repository
        state = state.copyWith(loanAreas: areasList);
      },
    );
  }

  void selectLoanArea(LoanArea? area) => state = state.copyWith(selectedLoanArea: area);

  Future<void> createAndSelectLoanArea({required String name, String? phone, String? address}) async {
    state = state.copyWith(isLoading: true);
    final useCase = ref.read(createLoanAreaUseCaseProvider);
    
    final result = await useCase({
      "name": name,
      "contact": phone ?? "",
      "address": address ?? ""
    });

    result.fold(
      (f) => state = state.copyWith(isLoading: false),
      (newArea) {
        state = state.copyWith(
          loanAreas: [...state.loanAreas, newArea],
          selectedLoanArea: newArea,
          isLoading: false,
        );
      }
    );
  }

  Future<void> onSerieSelected(String serie) async {
    state = state.copyWith(isLoading: true);
    final useCase = ref.read(getPressBySerieProvider);
    final result = await useCase(serie);
    result.fold(
      (f) => state = state.copyWith(isLoading: false),
      (press) => state = state.copyWith(selectedPress: press, isLoading: false),
    );
  }

  void onSerieChanged(String serie) {
    if (serie.isEmpty) state = state.copyWith(clearPress: true);
  }
}