import 'package:crv_reprosisa/features/ocr/data/datasources/opencv_datasource.dart';
import 'package:crv_reprosisa/features/ocr/data/repositories/image_processor_repository_impl.dart';
import 'package:crv_reprosisa/features/ocr/domain/usecase/process_image_usecase.dart';
import 'package:crv_reprosisa/features/ocr/presentation/notifiers/image_processor_notifier.dart';
import 'package:crv_reprosisa/features/ocr/presentation/state/image_processing_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final openCVDataSourceProvider = Provider((ref) => OpenCVDataSource());

final imageProcessorRepositoryProvider = Provider((ref) {
  return ImageProcessorRepositoryImpl(ref.read(openCVDataSourceProvider));
});

final proccessImageUseCaseProvider = Provider((ref) {
  return ProcessImageUseCase(ref.read(imageProcessorRepositoryProvider));
});

final imageProcessingProvider =
    StateNotifierProvider<
        ImageProcessingNotifier,
        ImageProcessingState
    >((ref) {


  return ImageProcessingNotifier(
    ref.read(proccessImageUseCaseProvider),
  );

});