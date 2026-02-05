class ReportsConveyor{
  final String id;
  final String conveyor_id;
  final DateTime inspection_id;
  final String inspector_id;
  final String? conveyot_responsible;
  final String? recommended_balt;
  final String? material;
  final String? granulometry;
  final String? present_to;
  final String state;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool is_active;
  final String folio;

  ReportsConveyor({
    required this.id,
    required this.conveyor_id,
    required this.inspection_id,
    required this.inspector_id,
    this.conveyot_responsible,
    this.recommended_balt,
    this.material,
    this.granulometry,
    this.present_to,
    required this.state,
    required this.createdAt,
    required this.updatedAt,
    required this.is_active,
    required this.folio,
  });
}