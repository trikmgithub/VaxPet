import '../../../domain/disease/entities/disease.dart';

abstract class DiseaseSpeciesState {}

class DiseaseSpeciesLoading extends DiseaseSpeciesState {}

class DiseaseSpeciesLoaded extends DiseaseSpeciesState {
  final List<DiseaseEntity> diseases;
  DiseaseSpeciesLoaded({required this.diseases});
}

class DiseaseSpeciesError extends DiseaseSpeciesState {
  final String message;

  DiseaseSpeciesError({required this.message});
}
