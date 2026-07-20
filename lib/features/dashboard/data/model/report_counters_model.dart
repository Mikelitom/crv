class ReportCountersModel {
  final int totalToday;
  final int totalPress;
  final int totalVehicles;
  final int totalConveyor;

  ReportCountersModel({
    required this.totalToday,
    required this.totalPress,
    required this.totalVehicles,
    required this.totalConveyor,
  });

  factory ReportCountersModel.fromJson(Map<String, dynamic> json) {
    return ReportCountersModel(
      totalToday: json['total_today'] ?? 0,
      totalPress: json['total_press'] ?? 0,
      totalVehicles: json['total_vehicles'] ?? 0,
      totalConveyor: json['total_conveyor'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_today': totalToday,
      'total_press': totalPress,
      'total_vehicles': totalVehicles,
      'total_conveyor': totalConveyor,
    };
  }
}