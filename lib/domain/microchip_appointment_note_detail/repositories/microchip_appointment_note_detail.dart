import 'package:dartz/dartz.dart';

import '../../../data/microchip_appointment_note_detail/models/put_microchip_appointment_note.dart';

abstract class MicrochipAppointmentNoteDetailRepository {
  //Get
  Future<Either> getMicrochipAppointmentNoteDetail(int appointmentId);
  //Put
  Future<Either> putMicrochipAppointmentNoteDetail(PutMicrochipAppointmentModel appointmentUpdate);
}
