import 'package:crv_reprosisa/domain/entities/conveyors/clients_conveyor.dart';
import 'package:crv_reprosisa/domain/usecases/conveyor/clients_conveyor_use_cases.dart';
import 'package:crv_reprosisa/features/activos/presentation/providers/form_notifier.dart';
import 'package:crv_reprosisa/features/activos/presentation/states/create_form_state.dart';

class CreateClientNotifier extends FormNotifier<ClientsConveyor> {
  late final CreateClientsConveyorUseCase _createClient;

  @override
  FormState<ClientsConveyor> build() {
      _createClient = ref.read(CreateClientsConveyorUseCase);
      return const FormState.initial();
  }

  Future<void> create( 
    String name, 
    String company,
    String phone,
    String email,
    String address
  )
}
