// lib/features/servicios/presentation/providers/press/press_items_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/service_press_provider.dart';

// Este provider ahora obtiene las órdenes de servicio de la prensa
final pendingItemsProvider = FutureProvider.family<List<dynamic>, String>((ref, pressId) async {
  final dataSource = ref.read(pressServiceDataSourceProvider);
  // Llamamos al método que obtiene las órdenes de servicio por ID de prensa
  return await dataSource.getServiceOrders(pressId);
});