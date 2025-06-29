import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../repositories/customer_profile.dart';

class GetCustomerProfileUseCase extends UseCase<Either, int> {
  @override
  Future<Either> call({int? params}) async {
    return await sl<CustomerProfileRepository>().getCustomerProfile(params!);
  }

}