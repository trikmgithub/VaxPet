import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../repositories/health_certificate_appointment_note_detail.dart';

class GetHealthCertificateAppointmentNoteDetailUseCase extends UseCase<Either, int> {
  @override
  Future<Either> call({int? params}) async {
    return await sl<HealthCertificateAppointmentNoteDetailRepository>()
        .getHealthCertificateAppointmentNoteDetail(params!);
  }
}
