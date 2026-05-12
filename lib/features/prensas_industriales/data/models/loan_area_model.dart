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
      // Usamos el operador de nulidad por seguridad
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      address: json['address']?.toString(),
      contact: json['contact']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id, // Agregué el ID por si necesitas actualizar
    "name": name,
    "address": address,
    "contact": contact,
  };
}