class ConnectionState {
  final bool isConnected;
  final bool isSyncing;
  final int pendingReports;
  final DateTime? lastSync;
  final String? syncMessage;

  const ConnectionState({
    this.isConnected = true,
    this.isSyncing = false,
    this.pendingReports = 0,
    this.lastSync,
    this.syncMessage,
  });

  ConnectionState copyWith({
    bool? isConnected,
    bool? isSyncing,
    int? pendingReports,
    DateTime? lastSync,
    String? syncMessage,
    bool clearSyncMessage = false,
  }) {
    return ConnectionState(
      isConnected: isConnected ?? this.isConnected,
      isSyncing: isSyncing ?? this.isSyncing,
      pendingReports: pendingReports ?? this.pendingReports,
      lastSync: lastSync ?? this.lastSync,
      syncMessage: clearSyncMessage
          ? null
          : (syncMessage ?? this.syncMessage),
    );
  }
}