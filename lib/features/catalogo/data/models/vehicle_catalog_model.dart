class VehicleCatalogModel {
  final String plate;
  final String name;
  final String? responsible;
  final String? phone;
  final DateTime? checkout;
  final int? mileage;
  final String? location;
  final String? state;

  VehicleCatalogModel({
    required this.plate,
    required this.name,
    this.responsible,
    this.phone,
    this.checkout,
    this.mileage,
    this.location,
    this.state,
  });

  factory VehicleCatalogModel.fromJson(Map<String, dynamic> json) {
    return VehicleCatalogModel(
      plate: json['plate'],
      name: json['name'],
      responsible: json['responsible'],
      phone: json['phone'],
      checkout: json['checkout'] != null
          ? DateTime.parse(json['checkout'])
          : null,
      mileage: json['mileage'],
      location: json['location'],
      state: json['state'],
    );
  }
}

