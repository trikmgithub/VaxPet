import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaxpet/presentation/home/bloc/pets_state.dart';

import '../../../domain/pet/usecases/get_pets.dart';
import '../../../service_locator.dart';

class PetsCubit extends Cubit<PetsState> {
  PetsCubit() : super(PetsLoading());

  void getPets(int accountId) async {
    debugPrint('🔍 PetsCubit: Fetching pets for account ID: $accountId');

    try {
      final result = await sl<GetPetsUseCase>().call(params: accountId);

      result.fold(
        (error) {
          debugPrint('❌ PetsCubit: Error fetching pets: $error');
          emit(PetsError(error));
        },
        (data) {
          debugPrint('✅ PetsCubit: Successfully loaded ${data.length} pets');
            emit(PetsLoaded(pets: data));
        }
      );
    } catch (e, stackTrace) {
      debugPrint('⚠️ PetsCubit: Unexpected error: $e');
      debugPrint('Stack trace: $stackTrace');
      emit(PetsError(e.toString()));
    }
  }
}