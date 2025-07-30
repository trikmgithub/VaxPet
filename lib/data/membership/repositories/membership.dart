import 'package:dartz/dartz.dart';

import '../../../domain/membership/repositories/membership.dart';
import '../../../service_locator.dart';
import '../sources/membership.dart';

class MembershipRepositoryImpl extends MembershipRepository {
  @override
  Future<Either> getMembershipByCustomerId(int customerId) async {
    var returnedData = await sl<MembershipService>().getMembershipByCustomerId(customerId);

    return returnedData.fold(
      (error) => Left(Exception(error.toString())),
      (data) {
        var customerRankingInfo = data;
        return Right(customerRankingInfo);
      },
    );
  }

  @override
  Future<Either> getMembershipStatusByCustomerId(int customerId) async {
    var returnedData = await sl<MembershipService>().getMembershipStatusByCustomerId(customerId);

    return returnedData.fold(
      (error) => Left(Exception(error.toString())),
      (data) {
        var membershipRanking = data;
        return Right(membershipRanking);
      },
    );
  }

}