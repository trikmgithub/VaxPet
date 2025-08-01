import 'package:dartz/dartz.dart';

abstract class SampleSchedulePetRepository {
  //Get
  Future<Either> getSampleSchedulePet(String species);

}