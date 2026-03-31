class PressLoanModel {
  final String id;
  final String? reportId;
  final String pressId;
  final String? responsibleId;
  final String? area;
  final String? solicitantsName;
  final String? observations;
  final DateTime? loanDate;
  final DateTime? expectedReturnDate;
  final DateTime? actualReturnDate;
  final String? status;
  final bool isActive;

  PressLoanModel({
    required this.id,
    this.reportId,
    required this.pressId,
    this.responsibleId,
    this.area,
    this.solicitantsName,
    this.observations,
    this.loanDate,
    this.expectedReturnDate,
    this.actualReturnDate,
    this.status,
    required this.isActive,
  });

  factory PressLoanModel.fromJson(Map<String, dynamic> json) {
    return PressLoanModel(
      id: json['id']?.toString() ?? '',
      reportId: json['report_id']?.toString(),
      pressId: json['press_id']?.toString() ?? '',
      responsibleId: json['responsible_id']?.toString(),
      area: json['area']?.toString(),
      solicitantsName: json['solicitants_name']?.toString(),
      observations: json['observations']?.toString(),
      loanDate: json['loan_date'] != null ? DateTime.tryParse(json['loan_date'].toString()) : null,
      expectedReturnDate: json['expected_return_date'] != null ? DateTime.tryParse(json['expected_return_date'].toString()) : null,
      actualReturnDate: json['actual_return_date'] != null ? DateTime.tryParse(json['actual_return_date'].toString()) : null,
      status: json['status']?.toString(),
      isActive: json['is_active'] ?? true,
    );
  }
}