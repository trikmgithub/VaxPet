import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/constant/api_url.dart';
import '../../../core/network/dio_client.dart';
import '../../../service_locator.dart';

abstract class PointTransactionService {
  // Get
  Future<Either> getPointTransactionByCustomerId(int customerId);
}

class PointTransactionServiceImpl extends PointTransactionService {
  @override
  Future<Either> getPointTransactionByCustomerId(int customerId) async {
    try {
      final url = '${ApiUrl.getPointTransactionByCustomerId}/$customerId';

      final response = await sl<DioClient>().get(url);

      return Right(response.data);
    } on DioException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Exception('An unexpected error occurred'));
    }
  }
}