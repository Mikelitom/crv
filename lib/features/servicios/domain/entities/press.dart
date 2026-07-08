class Press {
  final String id;
  final String serie;
  final String size;
  final String type;
  final String model;
  final String volts;
  final bool isActive;
  final String operationState;
  final String currentLocation;
  final String solicitantsName;
  final String serviceReason;
  final String loanComment;
  final DateTime serviceDate;
  final DateTime checkoutDate;

  Press({
    required this.id,
    required this.serie,
    required this.size,
    required this.type,
    required this.model,
    required this.volts,
    required this.isActive,
    required this.operationState,
    required this.currentLocation,
    required this.solicitantsName,
    required this.serviceReason,
    required this.loanComment,
    required this.serviceDate,
    required this.checkoutDate,
  });
}