import 'package:dartz/dartz.dart';

import '../../../data/pet/models/create_pet_req_params.dart';
import '../entities/pet.dart';

abstract class PetRepository {
  //Get
  Future<Either<String, List<PetEntity>>> getPets(int accountId);

  //Post
  Future<Either> createPet(CreatePetReqParams pet);

  //Delete
  Future<Either> deletePet(int petId);

}