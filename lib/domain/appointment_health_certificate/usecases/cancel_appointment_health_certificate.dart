import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../repositories/appointment_health_certificate.dart';

class CancelAppointmentHealthCertificateUseCase
    extends UseCase<Either, int> {
  @override
  Future<Either> call({int? params}) async {
    return await sl<AppointmentHealthCertificateRepository>()
        .cancelAppointmentHealthCertificate(params!);
  }
}