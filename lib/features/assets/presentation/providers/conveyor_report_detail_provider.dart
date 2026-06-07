import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/conveyor_report_detail_notifier.dart';
import '../states/conveyor_report_detail_state.dart';

final conveyorReportDetailProvider = NotifierProvider<ConveyorReportDetailNotifier, ConveyorReportDetailState>(
  ConveyorReportDetailNotifier.new,
);