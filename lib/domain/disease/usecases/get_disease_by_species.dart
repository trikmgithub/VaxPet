import 'package:dartz/dartz.dart';
import 'package:vaxpet/core/usecase/usecase.dart';

import '../../../service_locator.dart';
import '../repositories/disease.dart';

class GetDiseaseBySpeciesUseCase extends UseCase<Either, String> {
  @override
  Future<Either> call({String? params}) {
    return sl<DiseaseRepository>().getDiseaseBySpecies(params!);
  }

}