import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaxpet/domain/pet/entities/pet.dart';
import 'package:vaxpet/domain/pet/usecases/put_pet.dart';
import 'package:vaxpet/presentation/pet_information/bloc/edit_pet_state.dart';
import '../../../service_locator.dart';

class EditPetCubit extends Cubit<EditPetState> {
  EditPetCubit() : super(EditPetInitial());

  Future<void> updatePet(PetEntity pet) async {
    emit(EditPetLoading());

    try {
      final result = await sl<PutPetUseCase>().call(params: pet);

      result.fold(
        (error) {
          emit(EditPetError(error));
        },
        (data) {
          emit(EditPetSuccess(pet: pet));
        },
      );
    } catch (e) {
      emit(EditPetError(e.toString()));
    }
  }
}
