import 'package:crv_reprosisa/features/assets/presentation/notifiers/create_vehicle_notifier.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/create_vehicle_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createVehicleProvider =
    NotifierProvider<CreateVehicleNotifier, CreateVehicleState>(
      CreateVehicleNotifier.new,
    );
