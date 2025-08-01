import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/sample_schedule_pet/usecases/get_sample_schedule_pet.dart';
import '../../../service_locator.dart';
import 'sample_schedule_pet_state.dart';

class SampleSchedulePetCubit extends Cubit<SampleSchedulePetState> {
  SampleSchedulePetCubit() : super(SampleSchedulePetLoading());

  void getSampleSchedulePet(String species) async {
    emit(SampleSchedulePetLoading());

    try {
      // Map Vietnamese species names to English for API
      String apiSpecies = _mapSpeciesToApiFormat(species);

      final result = await sl<GetSampleSchedulePetUseCase>().call(params: apiSpecies);

      result.fold(
        (failure) {
          emit(SampleSchedulePetFailure(errorMessage: failure.toString()));
        },
        (success) {
          if (success['success'] == true && success['data'] != null) {
            final List<SpeciesSchedule> speciesSchedules = (success['data'] as List<dynamic>)
                .map((e) => SpeciesSchedule.fromJson(e as Map<String, dynamic>))
                .toList();

            emit(SampleSchedulePetLoaded(speciesSchedules: speciesSchedules));
          } else {
            emit(SampleSchedulePetFailure(errorMessage: success['message'] ?? 'Unknown error'));
          }
        },
      );
    } catch (e) {
      emit(SampleSchedulePetFailure(errorMessage: e.toString()));
    }
  }

  String _mapSpeciesToApiFormat(String species) {
    final String lowerSpecies = species.toLowerCase();

    // Map Vietnamese species names to English
    switch (lowerSpecies) {
      case 'chó':
      case 'cho':
      case 'dog':
        return 'Dog';
      case 'mèo':
      case 'meo':
      case 'cat':
        return 'Cat';
      default:
        // If already in English format, capitalize first letter
        return species.substring(0, 1).toUpperCase() + species.substring(1).toLowerCase();
    }
  }
}
