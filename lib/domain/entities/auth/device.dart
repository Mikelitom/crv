class Device {
  final String deviceUuid;
  final String fcmToken;
  final String platform;
  final String? deviceName;

  Device({
    required this.deviceUuid,
    required this.fcmToken,
    required this.platform,
    this.deviceName,
  });
}
