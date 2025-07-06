import 'package:dartz/dartz.dart';
import 'package:vaxpet/data/appointment_health_certificate/models/post_appointment_health_certificate.dart';
import '../../../domain/appointment_health_certificate/repositories/appointment_health_certificate.dart';
import '../../../service_locator.dart';
import '../sources/appointment_health_certificate.dart';

class AppointmentHealthCertificateRepositoryImpl
    extends AppointmentHealthCertificateRepository {
  @override
  Future<Either> postAppointmentHealthCertificate(
    PostAppointmentHealthCertificateModel? params,
  ) async {
    var returnedData = await sl<AppointmentHealthCertificateService>()
        .postAppointmentHealthCertificate(params);
    return returnedData.fold((error) => Left(Exception(error.toString())), (
      data,
    ) {
      return Right(data);
    });
  }
}
