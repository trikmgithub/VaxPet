import 'package:dartz/dartz.dart';
import 'package:vaxpet/core/usecase/usecase.dart';

import '../../../service_locator.dart';
import '../repositories/pet.dart';

class DeletePetUseCase extends UseCase<Either, int> {
  @override
  Future<Either> call({int? params}) {
    return sl<PetRepository>().deletePet(params!);
  }

}