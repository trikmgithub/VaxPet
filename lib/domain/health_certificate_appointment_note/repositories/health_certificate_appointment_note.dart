import 'package:dartz/dartz.dart';

abstract class HealthCertificateAppointmentNoteRepository {
  Future<Either> getHealthCertificateAppointmentNote(int petId, int status);
}
