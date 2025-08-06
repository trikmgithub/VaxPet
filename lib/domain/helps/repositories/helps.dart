import 'package:dartz/dartz.dart';

abstract class HelpsRepository {
  //Get
  Future<Either> getSupports(Map<String, dynamic>? params);
  Future<Either> getFAQ(Map<String, dynamic>? params);

}