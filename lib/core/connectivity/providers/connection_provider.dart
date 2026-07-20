import 'package:crv_reprosisa/core/connectivity/models/connection_state.dart';
import 'package:crv_reprosisa/core/connectivity/notifier/connection_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final connectionProvider =
    NotifierProvider<ConnectionNotifier, ConnectionState>(
  ConnectionNotifier.new,
);