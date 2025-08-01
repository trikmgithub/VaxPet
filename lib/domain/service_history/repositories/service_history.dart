import 'package:dartz/dartz.dart';

abstract class ServiceHistoryRepository {
  //Get
  Future<Either> getServiceHistory(int customerId);

}