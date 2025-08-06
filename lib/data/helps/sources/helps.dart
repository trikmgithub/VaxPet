import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/constant/api_url.dart';
import '../../../core/network/dio_client.dart';
import '../../../service_locator.dart';

abstract class HelpsService {
  // Get
  Future<Either> getSupports(Map<String, dynamic>? params);
  Future<Either> getFAQ(Map<String, dynamic>? params);

}

class HelpsServiceImpl extends HelpsService {
  @override
  Future<Either> getSupports(Map<String, dynamic>? params) async {
    try {
      final url = ApiUrl.getSupports;

      final response = await sl<DioClient>().get(
          url,
          queryParameters: params
      );

      return Right(response.data);
    } on DioException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Exception('An unexpected error occurred'));
    }
  }

  @override
  Future<Either> getFAQ(Map<String, dynamic>? params) async {
    try {
      final url = ApiUrl.getFAQ;

      final response = await sl<DioClient>().get(
          url,
          queryParameters: params
      );

      return Right(response.data);
    } on DioException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Exception('An unexpected error occurred'));
    }
  }
  
}