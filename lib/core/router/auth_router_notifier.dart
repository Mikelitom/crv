import 'package:crv_reprosisa/features/auth/presentation/providers/auth_notifier_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_notifier.dart';

class AuthRouterNotifier extends ChangeNotifier {
  AuthRouterNotifier(this.ref) {
    ref.listen(authNotifierProvider, (_, __) {
      notifyListeners();
    });
  }

  final Ref ref;

  bool get isAuthenticated => ref.read(authNotifierProvider).isAuthenticated;

  String? get role => ref.read(authNotifierProvider).user?.role[0];
}
