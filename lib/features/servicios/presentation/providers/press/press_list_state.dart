// lib/features/assets/presentation/states/press_list_state.dart
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';

import '../../../../prensas_industriales/domain/entities/entities_press.dart';


class PressListState {
  final Status status;
  final List<Press> press;
  final String? errorMessage;

  PressListState({
    required this.status,
    required this.press,
    this.errorMessage,
  });

  factory PressListState.initial() => PressListState(
        status: Status.initial,
        press: [],
      );

  PressListState copyWith({
    Status? status,
    List<Press>? press,
    String? errorMessage,
  }) {
    return PressListState(
      status: status ?? this.status,
      press: press ?? this.press,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}