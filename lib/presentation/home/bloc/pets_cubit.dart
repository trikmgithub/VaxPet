import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaxpet/presentation/home/bloc/pets_state.dart';

import '../../../domain/pet/usecases/get_pets.dart';
import '../../../service_locator.dart';

class PetsCubit extends Cubit<PetsState> {
  PetsCubit() : super(PetsLoading());

  // Phương thức lấy tất cả thú cưng
  void getPets(int accountId) async {
    emit(PetsLoading());

    try {
      final result = await sl<GetPetsUseCase>().call(params: accountId);

      result.fold(
        (error) {
          emit(PetsError(error));
        },
        (data) {
          emit(PetsLoaded(pets: data));
        }
      );
    } catch (e) {
      emit(PetsError(e.toString()));
    }
  }

  // Phương thức để refresh lại danh sách thú cưng
  Future<void> refreshPets(int accountId) async {
    try {
      final result = await sl<GetPetsUseCase>().call(params: accountId);

      result.fold(
        (error) {
          emit(PetsError(error));
        },
        (data) {
          emit(PetsLoaded(pets: data));
        }
      );
    } catch (e) {
      emit(PetsError(e.toString()));
    }
  }
}