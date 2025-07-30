import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../repositories/membership.dart';

class GetCustomerRankingInfoUseCase extends UseCase<Either, int> {
  @override
  Future<Either> call({int? params}) async {
    return await sl<MembershipRepository>().getMembershipByCustomerId(params!);
  }

}