import '../repository/report_repository.dart';

class SendConveyorNoteUseCase {
  final ReportRepository repository;

  SendConveyorNoteUseCase(this.repository);

  Future<void> call(String versionId, String notes) async {
    if (notes.isEmpty) throw Exception("La nota no puede estar vacía");
    
    return await repository.sendConveyorReviewNote(versionId, notes);
  }
}