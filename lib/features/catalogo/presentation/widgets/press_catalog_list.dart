import 'package:flutter/material.dart';
import 'press_table.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/press_list_notifier_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../assets/presentation/states/status.dart';
import 'catalogo_data_table.dart'; // Tu componente genérico

class PressCatalogList extends StatelessWidget {
  const PressCatalogList({super.key});

  @override
  Widget build(BuildContext context) {
    return const PressTable();
  }
}
