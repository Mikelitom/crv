import 'package:crv_reprosisa/features/assets/domain/entities/press.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';

class PressListState {
  final Status status;
  final List<Press> press;
  final String? error;

  const PressListState({
    this.status = Status.initial,
    this.press = const [],
    this.error,
  });

  PressListState copyWith({Status? status, List<Press>? press, String? error}) {
    return PressListState(
      status: status ?? this.status,
      press: press ?? this.press,
      error: error,
    );
  }
}
