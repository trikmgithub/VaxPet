import 'package:dartz/dartz.dart';
import 'package:vaxpet/common/helper/mapper/disease_mapper.dart';
import 'package:vaxpet/data/disease/sources/disease.dart';
import 'package:vaxpet/domain/disease/repositories/disease.dart';

import '../../../service_locator.dart';
import '../models/disease.dart';

class DiseaseRepositoryImpl extends DiseaseRepository {
  @override
  Future<Either> getDiseaseBySpecies(String species) async {
    var returnedData = await sl<DiseaseService>().getDiseaseBySpecies(species);

    return returnedData.fold(
      (error) => Left(Exception(error.toString())),
      (data) {
        var diseases = List.from(data['data']).map((item) => DiseaseMapper.toEntity(DiseaseModel.fromJson(item))).toList();
        return Right(diseases);
      },
    );
  }
  
}