import 'package:dartz/dartz.dart';

import '../../../data/appointment_health_certificate/models/post_appointment_health_certificate.dart';

abstract class AppointmentHealthCertificateRepository {
  // Post
  Future<Either> postAppointmentHealthCertificate(
    PostAppointmentHealthCertificateModel? params,
  );

  //Put
  Future<Either> cancelAppointmentHealthCertificate(int appointmentId);
}
