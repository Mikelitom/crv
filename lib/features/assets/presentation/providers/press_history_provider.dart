// lib/features/assets/presentation/providers/press_history_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/press_history_notifier.dart';
import '../states/press_history_state.dart';

final pressHistoryProvider = NotifierProvider<PressHistoryNotifier, PressHistoryState>(
  PressHistoryNotifier.new,
);