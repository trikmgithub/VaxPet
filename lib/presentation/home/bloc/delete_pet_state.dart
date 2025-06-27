abstract class DeletePetState {}

class DeletePetInitial extends DeletePetState {}

class DeletePetLoading extends DeletePetState {}

class DeletePetSuccess extends DeletePetState {
  final String message;

  DeletePetSuccess({required this.message});
}

class DeletePetError extends DeletePetState {
  final String message;

  DeletePetError(this.message);
}
