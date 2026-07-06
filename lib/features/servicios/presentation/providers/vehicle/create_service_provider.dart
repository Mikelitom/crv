// lib/features/servicios/presentation/providers/create_service_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/servicios/presentation/notifiers/create_service_notifier.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/vehicle/create_service_state.dart';

final createServiceNotifierProvider = NotifierProvider<CreateServiceNotifier, CreateServiceState>(() {
  return CreateServiceNotifier();
});