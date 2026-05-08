import '../../domain/entities/banda_template.dart';
import '../../domain/entities/client_mine.dart';

class BandaInspectionState {
  final bool isLoading;
  final List<Client> clients;
  final List<Mine> allMines; // Todas las minas de la API
  final List<Mine> filteredMines; // Solo las minas del cliente seleccionado
  final List<BandaSection> sections; // Secciones del template dinámico
  
  // Selección actual
  final Client? selectedClient;
  final Mine? selectedMine;
  final DateTime inspectionDate;
  final String elaboro; // Nombre del usuario actual

  BandaInspectionState({
    this.isLoading = false,
    this.clients = const [],
    this.allMines = const [],
    this.filteredMines = const [],
    this.sections = const [],
    this.selectedClient,
    this.selectedMine,
    required this.inspectionDate,
    this.elaboro = '',
  });

  BandaInspectionState copyWith({
    bool? isLoading,
    List<Client>? clients,
    List<Mine>? allMines,
    List<Mine>? filteredMines,
    List<BandaSection>? sections,
    Client? selectedClient,
    bool clearMine = false, // Para resetear la mina al cambiar cliente
    Mine? selectedMine,
    DateTime? inspectionDate,
    String? elaboro,
  }) {
    return BandaInspectionState(
      isLoading: isLoading ?? this.isLoading,
      clients: clients ?? this.clients,
      allMines: allMines ?? this.allMines,
      filteredMines: filteredMines ?? this.filteredMines,
      sections: sections ?? this.sections,
      selectedClient: selectedClient ?? this.selectedClient,
      selectedMine: clearMine ? null : (selectedMine ?? this.selectedMine),
      inspectionDate: inspectionDate ?? this.inspectionDate,
      elaboro: elaboro ?? this.elaboro,
    );
  }
}