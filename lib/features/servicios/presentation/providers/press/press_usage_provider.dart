// lib/features/servicios/presentation/providers/press/press_usage_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/service_press_provider.dart';

// lib/features/servicios/presentation/providers/press/press_items_provider.dart
final globalPendingMaintenanceProvider = FutureProvider<List<dynamic>>((ref) async {
  final dataSource = ref.read(pressServiceDataSourceProvider);
  return await dataSource.getPendingMaintenanceGlobal();
});

// lib/features/servicios/presentation/providers/press/press_usage_provider.dart
final pressUsageProvider = FutureProvider<List<dynamic>>((ref) async {
  final dataSource = ref.read(pressServiceDataSourceProvider);
  return await dataSource.getLoansMultiFilter(); 
});