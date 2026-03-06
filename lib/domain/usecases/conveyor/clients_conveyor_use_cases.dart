import '../base_use_case.dart';
import '../../entities/conveyors/clients_conveyor.dart';
import '../../repositories/conveyor/clients_conveyor_reposity.dart';

class GetAllClientsConveyorUseCase extends GetAllEntitiesUseCase<ClientsConveyor> {
  GetAllClientsConveyorUseCase(ClientsConveyorReposity repository) : super(repository);
}

// 2. Obtener un accesorio por ID (get_by_id)
class GetAreasConveyorByIdUseCase extends GetEntityByIdUseCase<ClientsConveyor> {
  GetAreasConveyorByIdUseCase(ClientsConveyorReposity repository) : super(repository);
}

// 3. Crear nuevo accesorio (create)
class CreateClientsConveyorUseCase extends CreateEntityUseCase<ClientsConveyor> {
  CreateClientsConveyorUseCase(ClientsConveyorReposity repository) : super(repository);
}

// 4. Actualizar accesorio (update)
class UpdateClientsConveyorUseCase extends UpdateEntityUseCase<ClientsConveyor> {
  UpdateClientsConveyorUseCase(ClientsConveyorReposity repository) : super(repository);
}

// 5. Eliminar accesorio (delete)
class DeleteClientsConveyorUseCase extends DeleteEntityUseCase<ClientsConveyor> {
  DeleteClientsConveyorUseCase(ClientsConveyorReposity repository) : super(repository);
}

// 6. Buscar por atributo (get_by_attribute)
class GetClientsConveyorByAttributeUseCase extends GetEntitiesByAttributeUseCase<ClientsConveyor> {
  GetClientsConveyorByAttributeUseCase(ClientsConveyorReposity repository) : super(repository);
}

// 7. Buscador general (search) - Vital para evitar el Right Overflow
class SearchClientsConveyorUseCase extends SearchEntitiesUseCase<ClientsConveyor> {
  SearchClientsConveyorUseCase(ClientsConveyorReposity repository) : super(repository);
}