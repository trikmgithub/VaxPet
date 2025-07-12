import 'package:dartz/dartz.dart';
import 'package:vaxpet/core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../repositories/health_certificate_appointment_note.dart';

class GetHealthCertificateAppointmentNoteUseCase
    extends UseCase<Either, Map<String, dynamic>> {
  @override
  Future<Either> call({Map<String, dynamic>? params}) async {
    return await sl<HealthCertificateAppointmentNoteRepository>()
        .getHealthCertificateAppointmentNote(params?['petId'], params?['status']);
  }
}
