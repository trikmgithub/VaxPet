import 'package:vaxpet/domain/pet/entities/pet.dart';

abstract class EditPetState {}

class EditPetInitial extends EditPetState {}

class EditPetLoading extends EditPetState {}

class EditPetSuccess extends EditPetState {
  final PetEntity pet;

  EditPetSuccess({required this.pet});
}

class EditPetError extends EditPetState {
  final String message;

  EditPetError(this.message);
}
