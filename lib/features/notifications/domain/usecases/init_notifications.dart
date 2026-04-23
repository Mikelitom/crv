import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/notifications/domain/entities/device.dart';
import 'package:crv_reprosisa/features/notifications/domain/repositories/device_repository.dart';
import 'package:crv_reprosisa/features/notifications/presentation/providers/token_provider.dart';
import 'package:dartz/dartz.dart';

class InitNotifications {
  final TokenProvider tokenProvider;
  final DeviceRepository repository;

  InitNotifications(this.tokenProvider, this.repository);

  Future<Either<Failure, void>> call(String deviceUuid, String platform) async {
    final permission = await tokenProvider.requestPermission();
    
    return await permission.fold(
        (l) => Left(l), 
        (_) async {
            final tokenResult = await tokenProvider.getToken();

            return tokenResult.fold(
                (l) => Left(l), 
                (token) async {
                    final device = Device(
                        deviceUuid: deviceUuid, 
                        fcmToken: token, 
                        platform: platform
                    );

                    return await repository.registerDevice(device);
                }
            )
        }
    )
  }
}
