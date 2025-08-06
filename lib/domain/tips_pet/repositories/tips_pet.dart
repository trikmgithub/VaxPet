import 'package:dartz/dartz.dart';

abstract class TipsPetRepository {
  //Get
  Future<Either> getAllHandbooks(Map<String, dynamic>? params);

}