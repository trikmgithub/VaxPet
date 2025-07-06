import 'package:dartz/dartz.dart';
import '../../../data/appointment_vaccination/models/post_appointment_vaccination.dart';

abstract class AppointmentVaccinationRepository {
  //Get
  //Post
  Future<Either> postAppointmentVaccination(
    PostAppointmentVaccinationModel params,
  );
}
