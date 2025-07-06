import 'package:dartz/dartz.dart';

abstract class DiseaseRepository {
  Future<Either> getDiseaseBySpecies(String species);
}
