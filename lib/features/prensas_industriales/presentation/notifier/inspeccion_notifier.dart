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

  void reset() {
    state = InspeccionState(
      inspectionDate: DateTime.now(), 
      loanAreas: state.loanAreas
    );
  }

  Future<void> onSerieSelected(String serie) async {
    state = state.copyWith(isLoading: true, status: '');

    // 1. Buscamos la prensa por serie
    final getPressUseCase = ref.read(getPressBySerieProvider);
    final result = await getPressUseCase(serie);

    await result.fold(
      (f) async => state = state.copyWith(isLoading: false), 
      (press) async {
        state = state.copyWith(selectedPress: press);

        // 2. LLAMADA AL USE CASE PARA OBTENER EL ÚLTIMO ESTADO (AHORA DEVUELVE MAP)
        final getStatusUseCase = ref.read(getLatestLoanStatusUseCaseProvider);
        final statusResult = await getStatusUseCase(press.id);

        statusResult.fold(
          (f) => state = state.copyWith(status: 'UNKNOWN', isLoading: false),
          (loanData) {
            // Extraemos el status para el badge visual
            final String currentStatus = loanData['status'] ?? 'AVAILABLE';
            
            // Lógica de autocompletado de área si la prensa está prestada (LOANED)
            LoanArea? autoSelectedArea;
            if (currentStatus == 'LOANED') {
              final String? areaId = loanData['area_id'];
              try {
                // Buscamos en la lista de áreas cargadas la que coincida con el ID
                autoSelectedArea = state.loanAreas.firstWhere((a) => a.id == areaId);
              } catch (_) {
                autoSelectedArea = null;
              }
            }

            state = state.copyWith(
              status: currentStatus,
              selectedLoanArea: autoSelectedArea, // Se asigna automáticamente si se encontró
              isLoading: false,
            );
          },
        );
      }
    );
  }

  void updateSolicitantsName(String name) =>
      state = state.copyWith(solicitantsName: name);
      
  void updateObservations(String obs) =>
      state = state.copyWith(observations: obs);
      
  void updateArea(String area) => state = state.copyWith(area: area);

  void onSerieChanged(String serie) {
    if (serie.isEmpty) state = state.copyWith(clearPress: true, status: '');
  }

  Future<void> loadLoanAreas() async {
    final useCase = ref.read(getLoanAreasUseCaseProvider);
    final result = await useCase();
    result.fold(
      (f) => null,
      (areasList) => state = state.copyWith(loanAreas: areasList),
    );
  }

  void selectLoanArea(LoanArea? area) =>
      state = state.copyWith(selectedLoanArea: area);

  Future<void> createAndSelectLoanArea({
    required String name,
    String? phone,
    String? address,
  }) async {
    state = state.copyWith(isLoading: true);
    final useCase = ref.read(createLoanAreaUseCaseProvider);
    final result = await useCase({
      "name": name,
      "contact": phone ?? "N/A",
      "address": address ?? "N/A",
    });
    result.fold(
      (f) => state = state.copyWith(isLoading: false),
      (newArea) => state = state.copyWith(
        loanAreas: [...state.loanAreas, newArea],
        selectedLoanArea: newArea,
        isLoading: false,
      ),
    );
  }
}