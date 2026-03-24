import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'profile_state.dart';
import 'profile_providers.dart';

class ProfileNotifier extends Notifier<ProfileState> {
  @override
  ProfileState build() {
    ref.keepAlive(); // 👈 🔥 clave

    Future.microtask(() => getUserProfile());
    return ProfileState.initial();
  }

  Future<void> getUserProfile() async {
    state = state.copyWith(status: ProfileStatus.loading);
    final result = await ref.read(getMeUseCaseProvider).call();
    result.fold(
      (f) => state = state.copyWith(status: ProfileStatus.error, error: f),
      (u) => state = state.copyWith(status: ProfileStatus.success, user: u),
    );
  }

  Future<void> updateInfo(String name, String email, String phone) async {
    state = state.copyWith(status: ProfileStatus.loading);
    final result = await ref.read(updateProfileUseCaseProvider).call(name: name, email: email, phone: phone);
    result.fold(
      (f) => state = state.copyWith(status: ProfileStatus.error, error: f),
      (u) => state = state.copyWith(status: ProfileStatus.success, user: u),
    );
  }

  Future<void> changePassword(String currentPassword, String newPassword, bool logoutOthers) async {
    state = state.copyWith(status: ProfileStatus.loading);
    final result = await ref.read(changePasswordUseCaseProvider).call(currentPassword: currentPassword, newPassword: newPassword, logoutOthers: logoutOthers);
    result.fold(
      (f) => state = state.copyWith(status: ProfileStatus.error, error: f),
      (u) => state = state.copyWith(status: ProfileStatus.success),
    );
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, ProfileState>(ProfileNotifier.new);
