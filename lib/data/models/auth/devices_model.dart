class DevicesModel {
  final String id;
  final String user_id;
  final String device_uuid;
  final String device_name;
  final String platform;
  final String app_version;
  final bool is_active;
  final DateTime last_Sean_at;
  final DateTime createdAt;
  final DateTime updatedAt;

  DevicesModel({
    required this.id,
    required this.user_id,
    required this.device_uuid,
    required this.device_name,
    required this.platform,
    required this.app_version,
    required this.is_active,
    required this.last_Sean_at,
    required this.createdAt,
    required this.updatedAt,
  });

}
