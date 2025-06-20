import 'package:vaxpet/domain/disease/entities/disease.dart';

import '../../../data/disease/models/disease.dart';

class DiseaseMapper {
  static DiseaseEntity toEntity(DiseaseModel disease) {
    return DiseaseEntity(
      diseaseId: disease.diseaseId,
      name: disease.name,
      description: disease.description,
      species: disease.species,
      symptoms: disease.symptoms,
      treatment: disease.treatment,
      status: disease.status,
    );
  }
}