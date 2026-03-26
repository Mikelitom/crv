import 'package:crv_reprosisa/features/assets/presentation/notifiers/vehicle_list_notifier.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/vehicle_list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final vehicleListProvider =
    NotifierProvider<VehicleListNotifier, VehicleListState>(
      VehicleListNotifier.new,
    );
