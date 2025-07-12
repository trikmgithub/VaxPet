import 'package:dartz/dartz.dart';
import '../../../domain/health_certificate_appointment_note/repositories/health_certificate_appointment_note.dart';
import '../../../service_locator.dart';
import '../sources/health_certificate_appointment_note.dart';

class HealthCertificateAppointmentNoteRepositoryImpl
    extends HealthCertificateAppointmentNoteRepository {
  @override
  Future<Either> getHealthCertificateAppointmentNote(int petId, int status) async {
    var returnedData = await sl<HealthCertificateAppointmentNoteService>()
        .getHealthCertificateAppointmentNote(petId, status);

    return returnedData.fold(
      (error) => Left(Exception(error.toString())),
      (data) {
        var appointmentNotes =
        List.from(data['data']).map((item) => item).toList();
        return Right(appointmentNotes);
      }
    );
  }
}
