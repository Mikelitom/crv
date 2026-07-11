class AssetLastMovement {
  final String identifier;
  final String assetType;
  final String state;
  final DateTime eventDate;
  final String userName;
  final String movementType;

  const AssetLastMovement({
    required this.identifier,
    required this.assetType,
    required this.state,
    required this.eventDate,
    required this.userName,
    required this.movementType,
  });

  factory AssetLastMovement.fromJson(Map<String, dynamic> json) {
    return AssetLastMovement(
      identifier: json['identifier'],
      assetType: json['asset_type'],
      state: json['state'],
      eventDate: DateTime.parse(json['event_date']),
      userName: json['user_name'],
      movementType: json['movement_type'],
    );
  }
}