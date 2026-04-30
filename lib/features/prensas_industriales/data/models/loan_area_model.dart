import '../../domain/entities/loan_area.dart';

class LoanAreaModel extends LoanArea {
  LoanAreaModel({
    required super.id, 
    required super.name, 
    super.address, 
    super.contact
  });

  factory LoanAreaModel.fromJson(Map<String, dynamic> json) {
    return LoanAreaModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      address: json['address'],
      contact: json['contact'],
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "address": address,
    "contact": contact,
  };
}