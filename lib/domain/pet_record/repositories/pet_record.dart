import 'package:dartz/dartz.dart';
import '../../../data/appointment_vaccination/models/post_appointment_vaccination.dart';

abstract class PetRecordRepository {
  //Get
  Future<Either> getPetRecord(int petId);
}
