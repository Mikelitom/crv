import 'dart:io';

import 'package:crv_reprosisa/features/notifications/domain/providers/platform_provider.dart';

class PlatformProviderImpl implements PlatformProvider {
  @override
  String getPlatform() {
    if (Platform.isAndroid) return "android";
    if (Platform.isIOS) return "ios";
    if (Platform.isMacOS) return "macos";
    if (Platform.isWindows) return "windows";
    if (Platform.isLinux) return "linux";
    return "unknown";
  }
}
