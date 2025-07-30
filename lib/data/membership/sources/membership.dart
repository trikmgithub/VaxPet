import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/constant/api_url.dart';
import '../../../core/network/dio_client.dart';
import '../../../service_locator.dart';

abstract class MembershipService {
  // Get
  Future<Either> getMembershipByCustomerId(int customerId);
  Future<Either> getMembershipStatusByCustomerId(int customerId);
}

class MembershipServiceImpl extends MembershipService {
  @override
  Future<Either> getMembershipByCustomerId(int customerId) async {
    try {
      final url = '${ApiUrl.getCustomerRankingInfo}/$customerId';

      final response = await sl<DioClient>().get(url);

      return Right(response.data);
    } on DioException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Exception('An unexpected error occurred'));
    }
  }

  @override
  Future<Either> getMembershipStatusByCustomerId(int customerId) async {
    try {
      final url = '${ApiUrl.getMembershipStatus}/$customerId';

      final response = await sl<DioClient>().get(url);

      return Right(response.data);
    } on DioException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Exception('An unexpected error occurred'));
    }
  }

}