import 'package:vaxpet/domain/pet/entities/pet.dart';

abstract class PetInformationState {}

class PetInformationLoading extends PetInformationState {}

class PetInformationLoaded extends PetInformationState {
  final PetEntity pet;

  PetInformationLoaded({required this.pet});

  PetInformationLoaded copyWith({PetEntity? pet}) {
    return PetInformationLoaded(pet: pet ?? this.pet);
  }
}

class PetInformationError extends PetInformationState {
  final String message;

  PetInformationError(this.message);
}
