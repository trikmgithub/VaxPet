import 'package:dartz/dartz.dart';
import 'package:vaxpet/data/customer_profile/models/customer_profile.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../repositories/customer_profile.dart';

class PutCustomerProfileUseCase extends UseCase<Either, CustomerProfileModel> {
  @override
  Future<Either> call({CustomerProfileModel? params}) async {
    return await sl<CustomerProfileRepository>().putCustomerProfile(params!);
  }
}
