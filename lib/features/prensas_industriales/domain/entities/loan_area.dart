class LoanArea {
  final String id;
  final String name;
  final String? address;
  final String? contact;

  LoanArea({
    required this.id,
    required this.name,
    this.address,
    this.contact,
  });

  factory LoanArea.fromJson(Map<String, dynamic> json) {
    return LoanArea(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      address: json['address']?.toString(),
      contact: json['contact']?.toString(),
    );
  }
}