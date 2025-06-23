import 'package:dartz/dartz.dart';

abstract class VaccineAppointmentNoteRepository {
  Future<Either> getVaccineAppointmentNote(int petId, int status);
}