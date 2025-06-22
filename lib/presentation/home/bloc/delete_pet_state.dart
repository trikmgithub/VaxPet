abstract class DeletePetState {}

class DeletePetInitial extends DeletePetState {}

class DeletePetLoading extends DeletePetState {}

class DeletePetSuccess extends DeletePetState {
  final String message;

  DeletePetSuccess({this.message = 'Xóa thú cưng thành công'});
}

class DeletePetError extends DeletePetState {
  final String message;

  DeletePetError(this.message);
}
