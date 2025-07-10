import 'package:dartz/dartz.dart';
import 'package:vaxpet/core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../repositories/appointment_vaccination.dart';

class CancelAppointmentVaccinationUseCase
    extends UseCase<Either, int> {
  @override
  Future<Either> call({int? params}) async {
    return await sl<AppointmentVaccinationRepository>()
        .cancelAppointmentVaccination(params!);
  }
}
