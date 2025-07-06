import 'package:dartz/dartz.dart';
import 'package:vaxpet/core/usecase/usecase.dart';

import '../../../data/pet/models/create_pet_req_params.dart';
import '../../../service_locator.dart';
import '../repositories/pet.dart';

class CreatePetUseCase extends UseCase<Either, CreatePetReqParams> {
  @override
  Future<Either> call({CreatePetReqParams? params}) {
    return sl<PetRepository>().createPet(params!);
  }
}
