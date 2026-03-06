import '../repositories/base_repository.dart';

// --- CASOS DE USO GENÉRICOS ---

// 1. Obtener todos los registros (get_all)
class GetAllEntitiesUseCase<T> {
  final BaseRepository<T> repository;
  GetAllEntitiesUseCase(this.repository);

  Future<List<T>> execute() async => await repository.getAll();
}

// 2. Obtener por ID (get_by_id)
class GetEntityByIdUseCase<T> {
  final BaseRepository<T> repository;
  GetEntityByIdUseCase(this.repository);

  Future<T> execute(String id) async => await repository.getById(id);
}

// 3. Crear nuevo registro (create)
class CreateEntityUseCase<T> {
  final BaseRepository<T> repository;
  CreateEntityUseCase(this.repository);

  Future<void> execute(T item) async => await repository.create(item);
}

// 4. Actualizar registro (update)
class UpdateEntityUseCase<T> {
  final BaseRepository<T> repository;
  UpdateEntityUseCase(this.repository);

  Future<void> execute(T item) async => await repository.update(item);
}

// 5. Eliminar registro (delete)
class DeleteEntityUseCase<T> {
  final BaseRepository<T> repository;
  DeleteEntityUseCase(this.repository);

  Future<void> execute(String id) async => await repository.delete(id);
}

// 6. Buscar por atributo específico (get_by_attribute)
class GetEntitiesByAttributeUseCase<T> {
  final BaseRepository<T> repository;
  GetEntitiesByAttributeUseCase(this.repository);

  Future<List<T>> execute(String attr, String value) async =>
      await repository.getByAttribute(attr, value);
}

// 7. Buscador general (search)
class SearchEntitiesUseCase<T> {
  final BaseRepository<T> repository;
  SearchEntitiesUseCase(this.repository);

  Future<List<T>> execute(String query) async => await repository.search(query);
}

