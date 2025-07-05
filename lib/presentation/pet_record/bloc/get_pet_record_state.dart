import '../../../domain/pet_record/entities/pet_record.dart';

abstract class GetPetRecordState {}

class GetPetRecordLoading extends GetPetRecordState {}

class GetPetRecordLoaded extends GetPetRecordState {
  final List<PetRecordEntity> petRecords;

  GetPetRecordLoaded({required this.petRecords});
}

class GetPetRecordError extends GetPetRecordState {
  final String message;

  GetPetRecordError(this.message);
}
