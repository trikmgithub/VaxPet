import 'package:dartz/dartz.dart';

abstract class MembershipRepository {
  //Get
  Future<Either> getMembershipByCustomerId(int customerId);
  Future<Either> getMembershipStatusByCustomerId(int customerId);
}