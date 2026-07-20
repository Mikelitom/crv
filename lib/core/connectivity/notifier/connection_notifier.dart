import 'package:crv_reprosisa/core/connectivity/models/connection_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectionNotifier extends Notifier<ConnectionState> {

  @override
  ConnectionState build() {
    return const ConnectionState();
  }

  void setConnected(bool connected) {
    state = state.copyWith(
      isConnected: connected,
    );
  }

  void setSyncing(bool syncing) {
    state = state.copyWith(
      isSyncing: syncing,
    );
  }

  void setPendingReports(int pending) {
    state = state.copyWith(
      pendingReports: pending,
    );
  }

  void syncCompleted() {
    state = state.copyWith(
      isSyncing: false,
      pendingReports: 0,
      lastSync: DateTime.now(),
    );
  }

  void syncStarted() {
    state = state.copyWith(
      isConnected: true,
      isSyncing: true,
    );
  }

  void setSyncMessage(String message) {
    state = state.copyWith(
      syncMessage: message,
    );
  }
  
  
  void clearSyncMessage() {
    state = state.copyWith(
      clearSyncMessage: true,
    );
  }

}