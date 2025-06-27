import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaxpet/domain/pet/usecases/delete_pet.dart';
import 'package:vaxpet/presentation/home/bloc/delete_pet_state.dart';
import 'package:vaxpet/service_locator.dart';

class DeletePetCubit extends Cubit<DeletePetState> {
  DeletePetCubit() : super(DeletePetInitial());

  Future<void> deletePet(int petId) async {
    emit(DeletePetLoading());

    try {
      final result = await sl<DeletePetUseCase>().call(params: petId);

      result.fold(
        (error) => emit(DeletePetError(error.toString())),
        (data) => emit(DeletePetSuccess(message: data['message']))
      );
    } catch (e) {
      emit(DeletePetError('Có lỗi xảy ra khi xóa thú cưng: ${e.toString()}'));
    }
  }
}
