import 'package:dartz/dartz.dart';

abstract class PetRecordRepository {
  //Get
  Future<Either> getPetRecord(int petId);
}
