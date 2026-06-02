import 'package:crv_reprosisa/features/auth/data/repositories/user_session_repository_impl.dart';
import 'package:crv_reprosisa/features/auth/domain/repositories/user_session_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final userSessionRepositoryProvider = Provider<UserSessionRepository>((ref) {
  return UserSessionRepositoryImpl(Hive.box('session'));
});
