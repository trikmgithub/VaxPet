import 'package:dartz/dartz.dart';

abstract class VaccineAppointmentNoteDetailRepository {
  // Get
  Future<Either> getVaccineAppointmentNoteDetail(int appointmentId);
  Future<Either> getAppointmentDetailForVaccinationById(int appointmentId);

}
