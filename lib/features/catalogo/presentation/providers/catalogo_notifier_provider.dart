import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/catalogo_notifier.dart';
import '../states/catalogo_state.dart';


// Definición estándar para Riverpod 3.0
final catalogoNotifierProvider = NotifierProvider<CatalogoNotifier, CatalogoState>(() {
  return CatalogoNotifier();
});