import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaxpet/presentation/disease/bloc/disease_species_state.dart';

import '../../../domain/disease/usecases/get_disease_by_species.dart';
import '../../../service_locator.dart';

class DiseaseSpeciesCubit extends Cubit<DiseaseSpeciesState> {
  DiseaseSpeciesCubit() : super(DiseaseSpeciesLoading());

  Future<void> getDiseaseBySpecies(String species) async {
    var returnedData = await sl<GetDiseaseBySpeciesUseCase>().call(params: species);

    returnedData.fold(
        (error) {
          emit(DiseaseSpeciesError(message: error));
        },
        (data) {
          debugPrint('getDiseaseBySpecies returned: $data');
          emit(DiseaseSpeciesLoaded(diseases: data));
        }
    );
  }

}