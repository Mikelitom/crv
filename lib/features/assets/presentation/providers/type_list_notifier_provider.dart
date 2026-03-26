import 'package:crv_reprosisa/features/assets/presentation/notifiers/type_list_notifier.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/type_list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final typeListProvider = NotifierProvider<TypeListNotifier, TypeListState>(
  TypeListNotifier.new,
);
