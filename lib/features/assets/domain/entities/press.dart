class Press {
  final String id;
  final String type;
  final String model;
  final String volts;
  final String serie;
  final String size;
  final bool isActive;
  final String? operationState;
  final String? currentLocation;
  final String? responsible;
  final String? serviceReason;
  final String? loanComment;
  final DateTime? serviceDate;
  final DateTime? checkoutDate;

  Press({
    required this.id,
    required this.type,
    required this.model,
    required this.volts,
    required this.serie,
    required this.size,
    required this.isActive,
    this.operationState,
    this.currentLocation,
    this.responsible,
    this.serviceReason,
    this.loanComment,
    this.serviceDate,
    this.checkoutDate,
  });
}
