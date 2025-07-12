import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../repositories/appointment_microchip.dart';

class CancelAppointmentMicrochipUseCase
    extends UseCase<Either, int> {
  @override
  Future<Either> call({int? params}) async {
    return await sl<AppointmentMicrochipRepository>()
        .cancelAppointmentMicrochip(params!);
  }
}