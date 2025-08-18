import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/constant/api_url.dart';
import '../../../core/network/dio_client.dart';
import '../../../service_locator.dart';

abstract class ServiceHistoryService {
  // Get
  Future<Either> getServiceHistory(int customerId);
}

class ServiceHistoryServiceImpl extends ServiceHistoryService {
  @override
  Future<Either> getServiceHistory(int customerId) async {
    try {
      final url = '${ApiUrl.getServiceHistories}/$customerId';

      final response = await sl<DioClient>().get(url);

      return Right(response.data);
    } on DioException catch (e) {
      return Left('Lỗi: ${e.response?.data['message']}');
    } catch (e) {
      return Left(Exception('An unexpected error occurred'));
    }
  }
  
}