import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../data/health_certificate_appointment_note_detail/models/put_health_certificate_appointment_note.dart';
import '../../../service_locator.dart';
import '../repositories/health_certificate_appointment_note_detail.dart';

class PutHealthCertificateAppointmentNoteUseCase
    extends UseCase<Either, PutHealthCertificateAppointmentModel> {
  @override
  Future<Either> call({PutHealthCertificateAppointmentModel? params}) {
    return sl<HealthCertificateAppointmentNoteDetailRepository>().putHealthCertificateAppointmentNoteDetail(params!);
  }
}