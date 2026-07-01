import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';

class CreateServiceState {
  final Status status;
  final String? error;
  final String? orderNumber; // 1. Agregamos el campo aquí

  const CreateServiceState({
    this.status = Status.initial,
    this.error,
    this.orderNumber, // 2. Lo añadimos al constructor
  });

  CreateServiceState copyWith({
    Status? status,
    String? error,
    String? orderNumber, // 3. Lo añadimos al copyWith
  }) {
    return CreateServiceState(
      status: status ?? this.status,
      error: error ?? this.error,
      orderNumber: orderNumber ?? this.orderNumber, // 4. Asignamos el valor
    );
  }
}