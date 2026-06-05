// lib/features/assets/presentation/providers/press_report_detail_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/press_report_detail_notifier.dart';
import '../states/press_report_detail_state.dart';

final pressReportDetailProvider = NotifierProvider<PressReportDetailNotifier, PressReportDetailState>(
  PressReportDetailNotifier.new,
);