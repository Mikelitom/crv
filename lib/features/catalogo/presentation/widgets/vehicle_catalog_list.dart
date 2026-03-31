import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'vehicle_table.dart';

class VehicleCatalogList extends StatelessWidget {
=======
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../assets/presentation/providers/vehicle_list_notifier_provider.dart';
import '../../../assets/presentation/states/status.dart';
class VehicleCatalogList extends ConsumerWidget {
>>>>>>> feb92f14e362a7b7e7c7a8117f3df58ec04fc178
  const VehicleCatalogList({super.key});

  @override
  Widget build(BuildContext context) {
    return const VehicleTable();
  }
}
