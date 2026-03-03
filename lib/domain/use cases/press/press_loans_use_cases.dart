import '../base_use_case.dart';
import '../../entities/press/press_loans.dart';
import '../../repositories/press/press_loans_reposity.dart';

class GetAllPressLoansUseCase extends GetAllEntitiesUseCase<PressLoans> {
  GetAllPressLoansUseCase(PressLoansReposity repository) : super(repository);
}

// 2. Obtener un accesorio por ID (get_by_id)
class GetAreasConveyorByIdUseCase extends GetEntityByIdUseCase<PressLoans> {
  GetAreasConveyorByIdUseCase(PressLoansReposity repository) : super(repository);
}

// 3. Crear nuevo accesorio (create)
class CreatePressLoansUseCase extends CreateEntityUseCase<PressLoans> {
  CreatePressLoansUseCase(PressLoansReposity repository) : super(repository);
}

// 4. Actualizar accesorio (update)
class UpdatePressLoansUseCase extends UpdateEntityUseCase<PressLoans> {
  UpdatePressLoansUseCase(PressLoansReposity repository) : super(repository);
}

// 5. Eliminar accesorio (delete)
class DeletePressLoansUseCase extends DeleteEntityUseCase<PressLoans> {
  DeletePressLoansUseCase(PressLoansReposity repository) : super(repository);
}

// 6. Buscar por atributo (get_by_attribute)
class GetPressLoansByAttributeUseCase extends GetEntitiesByAttributeUseCase<PressLoans> {
  GetPressLoansByAttributeUseCase(PressLoansReposity repository) : super(repository);
}

// 7. Buscador general (search) - Vital para evitar el Right Overflow
class SearchPressLoansUseCase extends SearchEntitiesUseCase<PressLoans> {
  SearchPressLoansUseCase(PressLoansReposity repository) : super(repository);
}