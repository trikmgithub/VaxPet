import 'package:dartz/dartz.dart';
import '../../../domain/appointment_vaccination/repositories/appointment_vaccination.dart';
import '../../../service_locator.dart';
import '../models/post_appointment_vaccination.dart';
import '../sources/appointment_vaccination.dart';

class AppointmentVaccinationRepositoryImpl extends AppointmentVaccinationRepository {
  @override
  Future<Either> postAppointmentVaccination(PostAppointmentVaccinationModel params) async {
    var returnedData = await sl<AppointmentVaccinationService>().postAppointmentVaccination(params);
    return returnedData.fold(
      (error) => Left(Exception(error.toString())),
      (data) {
        return Right(data);
      },
    );
  }

}