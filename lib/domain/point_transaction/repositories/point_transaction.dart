import 'package:dartz/dartz.dart';

abstract class PointTransactionRepository {
  //Get
  Future<Either> getPointTransactionByCustomerId(int customerId);
}