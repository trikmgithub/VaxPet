import 'package:dartz/dartz.dart';
import 'package:vaxpet/core/usecase/usecase.dart';
import 'package:vaxpet/data/appointment_health_certificate/models/post_appointment_health_certificate.dart';

import '../../../service_locator.dart';
import '../repositories/appointment_health_certificate.dart';

class PostAppointmentHealthCertificateUseCase extends UseCase<Either, PostAppointmentHealthCertificateModel> {

  @override
  Future<Either> call({PostAppointmentHealthCertificateModel? params}) async {
    return await sl<AppointmentHealthCertificateRepository>().postAppointmentHealthCertificate(params!);
  }

}