import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaxpet/presentation/pet_information/bloc/pet_information_state.dart';

import '../../../domain/pet/usecases/get_pet.dart';
import '../../../service_locator.dart';

class PetInformationCubit extends Cubit<PetInformationState> {
  PetInformationCubit() : super(PetInformationLoading());

  // Phương thức lấy thông tin thú cưng theo ID
  void getPetInformation(int petId) async {
    emit(PetInformationLoading());

    try {
      final result = await sl<GetPetUseCase>().call(params: petId);

      result.fold(
        (error) {
          emit(PetInformationError(error));
        },
        (data) {
          emit(PetInformationLoaded(pet: data));
        },
      );
    } catch (e) {
      emit(PetInformationError(e.toString()));
    }
  }

  // Phương thức để refresh lại thông tin thú cưng
  Future<void> refreshPetInformation(int petId) async {
    getPetInformation(petId);
  }
}
