import 'package:crv_reprosisa/features/ocr/domain/entities/scan_result.dart';

class ScanResultModel extends ScanResult {

  const ScanResultModel({
    required super.reportType,
    required super.generalInfo,
    required super.checklist,
    required super.confidence,
  });


  factory ScanResultModel.fromJson(Map<String,dynamic> json){

    return ScanResultModel(
      reportType: json['reportType'] ?? '',
      generalInfo: json['generalInfo'] ?? {},
      checklist: json['checklist'] ?? {},
      confidence: (json['confidence'] ?? 0).toDouble(),
    );

  }


  Map<String,dynamic> toJson(){

    return {
      "reportType": reportType,
      "generalInfo": generalInfo,
      "checklist": checklist,
      "confidence": confidence,
    };

  }

}