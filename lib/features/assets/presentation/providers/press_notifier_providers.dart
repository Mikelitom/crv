import 'package:crv_reprosisa/features/assets/presentation/notifiers/activate_press_notifier.dart';
import 'package:crv_reprosisa/features/assets/presentation/notifiers/deactivate_press_notifier.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/press_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final activatePressProvider = NotifierProvider<ActivatePressNotifier, PressState>(
  ActivatePressNotifier.new,
);

final deactivatePressProvider = NotifierProvider<DeactivatePressNotifier, PressState>(
  DeactivatePressNotifier.new,
);