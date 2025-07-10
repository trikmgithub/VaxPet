import 'package:dartz/dartz.dart';
import '../../../data/appointment_vaccination/models/post_appointment_vaccination.dart';

abstract class AppointmentVaccinationRepository {
  //Post
  Future<Either> postAppointmentVaccination(
    PostAppointmentVaccinationModel params,
  );
  //Put
  Future<Either> cancelAppointmentVaccination(
    int appointmentId,
  );
}
