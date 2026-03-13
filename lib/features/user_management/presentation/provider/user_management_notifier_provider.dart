import 'package:crv_reprosisa/features/user_management/presentation/provider/user_management_notifier.dart';
import 'package:crv_reprosisa/features/user_management/presentation/provider/user_management_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userManagementProvider =
    NotifierProvider<UserManagementNotifier, UserManagementState>(
      UserManagementNotifier.new,
    );
