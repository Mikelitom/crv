import 'package:crv_reprosisa/features/profile/domain/usecases/profile_use_case.dart';
import 'package:crv_reprosisa/features/profile/presentation/provider/change_password_state.dart';
import 'package:flutter_riverpod/legacy.dart';

class ChangePasswordNotifier
    extends StateNotifier<ChangePasswordState> {
  final ChangePasswordUseCase changePasswordUseCase;

  ChangePasswordNotifier(this.changePasswordUseCase)
      : super(ChangePasswordState.initial());

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required bool logoutOthers,
  }) async {
    state = state.copyWith(
      status: ChangePasswordStatus.loading,
      failure: null,
    );

    final result = await changePasswordUseCase(
      currentPassword: currentPassword,
      newPassword: newPassword,
      logoutOthers: logoutOthers,
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ChangePasswordStatus.error,
          failure: failure,
        );
      },
      (_) {
        state = state.copyWith(
          status: ChangePasswordStatus.success,
        );
      },
    );
  }
}
