import 'package:crv_reprosisa/features/prensas_industriales/data/models/loan_area_model.dart';
import 'package:crv_reprosisa/features/prensas_industriales/data/models/press_model.dart';

abstract class PressInspectionLocalDatasource {
  Future<void> savePresses(List<PressModel> presses);
  Future<List<PressModel>> getPresses();
  
  Future<void> saveLoanAreas(List<LoanAreaModel> loanAreas);
  Future<List<LoanAreaModel>> getLoanAreas();
  
  Future<void> savePressTemplate(Map<String, dynamic> template);
  Future<Map<String, dynamic>> getPressTemplate();
}
