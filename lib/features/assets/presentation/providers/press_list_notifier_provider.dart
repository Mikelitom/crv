import 'package:crv_reprosisa/features/assets/presentation/notifiers/press_list_notifier.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/press_list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pressListProvider = NotifierProvider<PressListNotifier, PressListState>(
  PressListNotifier.new,
);
