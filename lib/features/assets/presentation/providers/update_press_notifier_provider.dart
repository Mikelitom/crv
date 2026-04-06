import 'package:crv_reprosisa/features/assets/presentation/notifiers/update_press_notifier.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/press_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final updatePressProvider = NotifierProvider<UpdatePressNotifier, PressState>(
  UpdatePressNotifier.new,
);
