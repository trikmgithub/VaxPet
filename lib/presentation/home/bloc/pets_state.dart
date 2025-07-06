import 'package:vaxpet/domain/pet/entities/pet.dart';

abstract class PetsState {}

class PetsLoading extends PetsState {}

class PetsLoaded extends PetsState {
  final List<PetEntity> pets;

  PetsLoaded({required this.pets});

  PetsLoaded copyWith({List<PetEntity>? pets}) {
    return PetsLoaded(pets: pets ?? this.pets);
  }
}

class PetsError extends PetsState {
  final String message;

  PetsError(this.message);
}
