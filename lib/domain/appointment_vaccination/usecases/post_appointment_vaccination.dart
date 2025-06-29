import 'package:dartz/dartz.dart';
import 'package:vaxpet/core/usecase/usecase.dart';
import '../../../data/appointment_vaccination/models/post_appointment_vaccination.dart';
import '../../../service_locator.dart';
import '../repositories/appointment_vaccination.dart';

class PostAppointmentVaccinationUseCase extends UseCase<Either, PostAppointmentVaccinationModel> {
  @override
  Future<Either> call({PostAppointmentVaccinationModel? params}) async {
    return await sl<AppointmentVaccinationRepository>().postAppointmentVaccination(params!);
  }

}