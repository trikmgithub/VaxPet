import 'package:dartz/dartz.dart';

abstract class CustomerRepository {
  Future<Either> getCustomerById(int id);
}