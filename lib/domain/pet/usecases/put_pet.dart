import 'package:dartz/dartz.dart';
import 'package:vaxpet/core/usecase/usecase.dart';
import 'package:vaxpet/domain/pet/entities/pet.dart';

import '../../../service_locator.dart';
import '../repositories/pet.dart';

class CreatePetUseCase extends UseCase<Either, PetEntity> {
  @override
  Future<Either> call({PetEntity? params}) {
    return sl<PetRepository>().updatePet(params!);
  }

}