import '../base_use_case.dart';
import '../../entities/press/service_press.dart';
import '../../repositories/press/service_press_reposity.dart';

class GetAllServicePressUseCase extends GetAllEntitiesUseCase<ServicePress> {
  GetAllServicePressUseCase(ServicePressReposity repository) : super(repository);
}

// 2. Obtener un accesorio por ID (get_by_id)
class GetAreasConveyorByIdUseCase extends GetEntityByIdUseCase<ServicePress> {
  GetAreasConveyorByIdUseCase(ServicePressReposity repository) : super(repository);
}

// 3. Crear nuevo accesorio (create)
class CreateServicePressUseCase extends CreateEntityUseCase<ServicePress> {
  CreateServicePressUseCase(ServicePressReposity repository) : super(repository);
}

// 4. Actualizar accesorio (update)
class UpdateServicePressUseCase extends UpdateEntityUseCase<ServicePress> {
  UpdateServicePressUseCase(ServicePressReposity repository) : super(repository);
}

// 5. Eliminar accesorio (delete)
class DeleteServicePressUseCase extends DeleteEntityUseCase<ServicePress> {
  DeleteServicePressUseCase(ServicePressReposity repository) : super(repository);
}

// 6. Buscar por atributo (get_by_attribute)
class GetServicePressByAttributeUseCase extends GetEntitiesByAttributeUseCase<ServicePress> {
  GetServicePressByAttributeUseCase(ServicePressReposity repository) : super(repository);
}

// 7. Buscador general (search) - Vital para evitar el Right Overflow
class SearchServicePressUseCase extends SearchEntitiesUseCase<ServicePress> {
  SearchServicePressUseCase(ServicePressReposity repository) : super(repository);
}