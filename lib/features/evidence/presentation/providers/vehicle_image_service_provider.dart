import 'package:crv_reprosisa/features/evidence/presentation/providers/upload_file_usecase_provider.dart';
import 'package:crv_reprosisa/features/evidence/presentation/service/vehicle_image_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final vehicleImageServiceProvider = Provider((ref) {
  return VehicleImageService(ref.read(uploadFileUseCaseProvider));
});
