import 'package:flutter/material.dart';

enum UserRole { admin, technician }

class AuthSession extends ValueNotifier<UserRole?> {
  AuthSession() : super(null);

  bool get isAuthenticated => value != null;

  void setRole(UserRole role) {
    value = role;
  }

  void clear() {
    value = null;
  }
}

final authSession = AuthSession();