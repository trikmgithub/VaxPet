import 'package:dartz/dartz.dart';
import '../../../domain/microchip_appointment_note/repositories/microchip_appointment_note.dart';
import '../../../service_locator.dart';
import '../sources/microchip_appointment_note.dart';

class MicrochipAppointmentNoteRepositoryImpl
    extends MicrochipAppointmentNoteRepository {
  @override
  Future<Either> getMicrochipAppointmentNote(int petId, int status) async {
    var returnedData = await sl<MicrochipAppointmentNoteService>()
        .getMicrochipAppointmentNote(petId, status);

    return returnedData.fold((error) => Left(Exception(error.toString())), (
        data,
        ) {
      var appointmentNotes =
      List.from(data).map((item) => item['data']).toList();
      return Right(appointmentNotes);
    });
  }
}
