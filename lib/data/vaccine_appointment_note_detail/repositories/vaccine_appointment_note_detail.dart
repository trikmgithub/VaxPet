import 'package:dartz/dartz.dart';

import '../../../domain/vaccine_appointment_note_detail/repositories/vaccine_appointment_note_detail.dart';
import '../../../service_locator.dart';
import '../sources/vaccine_appointment_note_detail.dart';

class VaccineAppointmentNoteDetailRepositoryImpl
    extends VaccineAppointmentNoteDetailRepository {
  @override
  Future<Either> getVaccineAppointmentNoteDetail(int appointmentId) async {
    var returnedData = await sl<VaccineAppointmentNoteDetailService>()
        .getVaccineAppointmentNoteDetail(appointmentId);

    return returnedData.fold((error) => Left(Exception(error.toString())), (
      data,
    ) {
      var appointmentDetail = data;
      return Right(appointmentDetail);
    });
  }

  @override
  Future<Either> getAppointmentDetailForVaccinationById(int appointmentId) async {
    var returnedData = await sl<VaccineAppointmentNoteDetailService>()
        .getAppointmentDetailForVaccinationById(appointmentId);

    return returnedData.fold((error) => Left(Exception(error.toString())), (
        data,
        ) {
      var appointmentDetail = data;
      return Right(appointmentDetail);
    });
  }
}
