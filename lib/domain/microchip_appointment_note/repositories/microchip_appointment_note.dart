import 'package:dartz/dartz.dart';

abstract class MicrochipAppointmentNoteRepository {
  Future<Either> getMicrochipAppointmentNote(int petId, int status);
}
