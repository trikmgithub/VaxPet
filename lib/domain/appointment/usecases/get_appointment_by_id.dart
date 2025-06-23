import 'package:dartz/dartz.dart';
import 'package:vaxpet/core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../repositories/appointment.dart';

class GetAppointmentsByIdUseCase extends UseCase<Either, int> {
  @override
  Future<Either> call({int? params}) async {
    if (params == null) {
      throw ArgumentError('Parameters cannot be null for GetAppointmentsByIdUseCase');
    }
    return await sl<AppointmentRepository>().getAppointmentById(params);
  }
}
