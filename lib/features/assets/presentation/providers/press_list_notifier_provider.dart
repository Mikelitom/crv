// lib/features/assets/presentation/providers/press_list_notifier_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/press_list_notifier.dart';
import '../states/press_list_state.dart';

final pressListProvider = NotifierProvider<PressListNotifier, PressListState>(
  () => PressListNotifier(),
);