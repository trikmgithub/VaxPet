import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaxpet/presentation/pet_record/bloc/get_pet_record_state.dart';

import '../../../domain/pet_record/usecases/get_pet_record.dart';
import '../../../service_locator.dart';

class GetPetRecordCubit extends Cubit<GetPetRecordState> {
  GetPetRecordCubit() : super(GetPetRecordLoading());

  // Phương thức lấy hồ sơ tiêm chủng của thú cưng
  void getPetRecord(int petId) async {
    emit(GetPetRecordLoading());

    try {
      final result = await sl<GetPetRecordUseCase>().call(params: petId);

      result.fold(
        (error) {
          emit(GetPetRecordError(error));
        },
        (data) {
          emit(GetPetRecordLoaded(petRecords: data));
        }
      );
    } catch (e) {
      emit(GetPetRecordError(e.toString()));
    }
  }

  // Phương thức để refresh lại hồ sơ tiêm chủng
  Future<void> refreshPetRecord(int petId) async {
    getPetRecord(petId);
  }
}
