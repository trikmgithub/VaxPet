import 'package:dartz/dartz.dart';
import 'package:vaxpet/common/helper/mapper/customer_profile_mapper.dart';
import 'package:vaxpet/data/customer_profile/models/customer_profile.dart';

import '../../../domain/customer_profile/repositories/customer_profile.dart';
import '../../../service_locator.dart';
import '../sources/customer_profile.dart';

class CustomerProfileRepositoryImpl extends CustomerProfileRepository {
  @override
  Future<Either> getCustomerProfile(int accountId) async {
    var returnedData = await sl<CustomerProfileService>().getCustomerProfile(
      accountId,
    );

    return returnedData.fold(
      (error) => Left(Exception(error.toString())),
      (data) {
        var customerDetail = CustomerProfileMapper.toEntity(CustomerProfileModel.fromJson(data['data']));
        return Right(customerDetail);
      }
    );
  }

  @override
  Future<Either> putCustomerProfile(CustomerProfileModel customerProfile) async {
    var returnedData = await sl<CustomerProfileService>().putCustomerProfile(
      customerProfile,
    );

    return returnedData.fold(
      (error) => Left(Exception(error.toString())),
      (data) {
        return Right(data);
      }
    );
  }
  
}