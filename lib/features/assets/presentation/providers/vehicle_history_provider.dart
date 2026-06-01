import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/vehicle_history_notifier.dart';
import '../states/vehicle_history_state.dart';

final vehicleHistoryProvider = NotifierProvider<VehicleHistoryNotifier, VehicleHistoryState>(
  VehicleHistoryNotifier.new,
);