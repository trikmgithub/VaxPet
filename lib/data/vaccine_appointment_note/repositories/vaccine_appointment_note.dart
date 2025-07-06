import 'package:dartz/dartz.dart';

import '../../../domain/vaccine_appointment_note/repositories/vaccine_appointment_note.dart';
import '../../../service_locator.dart';
import '../sources/vaccine_appointment_note.dart';

class VaccineAppointmentNoteRepositoryImpl
    extends VaccineAppointmentNoteRepository {
  @override
  Future<Either> getVaccineAppointmentNote(int petId, int status) async {
    var returnedData = await sl<VaccineAppointmentNoteService>()
        .getVaccineAppointmentNote(petId, status);

    return returnedData.fold((error) => Left(Exception(error.toString())), (
      data,
    ) {
      var appointmentNotes =
          List.from(data['data']).map((item) => item).toList();
      return Right(appointmentNotes);
    });
  }
}
