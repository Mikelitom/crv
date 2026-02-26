import 'package:crv_reprosisa/core/router/auth_router_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRouterNotifierProvider = Provider<AuthRouterNotifier>((ref) {
  return AuthRouterNotifier(ref);
});
