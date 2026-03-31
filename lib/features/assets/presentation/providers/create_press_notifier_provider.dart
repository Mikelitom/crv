import 'package:crv_reprosisa/features/assets/presentation/notifiers/create_press_notifier.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/create_press_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createPressProvider =
    NotifierProvider<CreatePressNotifier, CreatePressState>(
      CreatePressNotifier.new,
    );
