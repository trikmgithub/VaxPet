import 'package:dartz/dartz.dart';
import 'package:vaxpet/core/usecase/usecase.dart';

import '../../../service_locator.dart';
import '../repositories/pet_record.dart';

class GetPetRecordUseCase extends UseCase<Either, int> {
  @override
  Future<Either> call({int? params}) {
    return sl<PetRecordRepository>().getPetRecord(params!);
  }

}