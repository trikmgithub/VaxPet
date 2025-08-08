import 'package:dartz/dartz.dart';

import '../../../data/health_certificate_appointment_note_detail/models/put_health_certificate_appointment_note.dart';

abstract class HealthCertificateAppointmentNoteDetailRepository {
  //Get
  Future<Either> getHealthCertificateAppointmentNoteDetail(int appointmentId);
  //Put
  Future<Either> putHealthCertificateAppointmentNoteDetail(PutHealthCertificateAppointmentModel appointmentUpdate);
}
