import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../repositories/membership.dart';

class GetMembershipStatusUseCase extends UseCase<Either, int> {
  @override
  Future<Either> call({int? params}) async {
    return await sl<MembershipRepository>().getMembershipStatusByCustomerId(params!);
  }

}