import 'package:dartz/dartz.dart';

import '../../../domain/health_certificate_appointment_note_detail/repositories/health_certificate_appointment_note_detail.dart';
import '../../../service_locator.dart';
import '../models/put_health_certificate_appointment_note.dart';
import '../sources/health_certificate_appointment_note_detail.dart';

class HealthCertificateAppointmentNoteDetailRepositoryImpl
    extends HealthCertificateAppointmentNoteDetailRepository {
  @override
  Future<Either> getHealthCertificateAppointmentNoteDetail(int appointmentId) async {
    var returnedData = await sl<HealthCertificateAppointmentNoteDetailService>()
        .getHealthCertificateAppointmentNoteDetail(appointmentId);

    return returnedData.fold(
            (error) => Left(Exception(error.toString())),
            (data) {
          var appointmentDetail = data;
          return Right(appointmentDetail);
        }
    );
  }

  @override
  Future<Either> putHealthCertificateAppointmentNoteDetail(PutHealthCertificateAppointmentModel appointmentUpdate) async {
    var returnedData = await sl<HealthCertificateAppointmentNoteDetailService>().putHealthCertificateAppointmentNoteDetail(
      appointmentUpdate,
    );

    return returnedData.fold((error) => Left(Exception(error.toString())), (
        data,
        ) {
      return Right(data);
    });
  }
}