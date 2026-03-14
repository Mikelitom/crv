import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/auth/domain/entities/user.dart';

enum ProfileStatus { initial, loading, success, error }

class ProfileState {
  final User? user;
  final ProfileStatus status;
  final Failure? error;

  ProfileState({
    this.user,
    required this.status,
    this.error,
  });

  factory ProfileState.initial() => ProfileState(
        status: ProfileStatus.initial,
      );

  ProfileState copyWith({
    User? user,
    ProfileStatus? status,
    Failure? error,
  }) {
    return ProfileState(
      user: user ?? this.user,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}