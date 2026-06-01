import 'package:crv_reprosisa/features/assets/presentation/notifiers/activate_vehicle_notifier.dart';
import 'package:crv_reprosisa/features/assets/presentation/notifiers/deactivate_vehicle_notifier.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/vehicle_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final activateVehicleProvider = NotifierProvider<ActivateVehicleNotifier, VehicleState>(
  ActivateVehicleNotifier.new,
);

final deactivateVehicleProvider = NotifierProvider<DeactivateVehicleNotifier, VehicleState>(
  DeactivateVehicleNotifier.new,
);