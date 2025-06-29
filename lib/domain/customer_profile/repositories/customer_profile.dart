import 'package:dartz/dartz.dart';

import '../../../data/customer_profile/models/customer_profile.dart';

abstract class CustomerProfileRepository {
  // Get
  Future<Either> getCustomerProfile(int accountId);
  // Put
  Future<Either> putCustomerProfile(CustomerProfileModel customerProfile);
}