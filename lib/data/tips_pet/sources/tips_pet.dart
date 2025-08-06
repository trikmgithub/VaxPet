import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/constant/api_url.dart';
import '../../../core/network/dio_client.dart';
import '../../../service_locator.dart';

abstract class TipsPetService {
  // Get
  Future<Either> getAllHandbooks(Map<String, dynamic>? params);
}

class TipsPetServiceImpl extends TipsPetService {
  @override
  Future<Either> getAllHandbooks(Map<String, dynamic>? params) async {
    try {
      final url = ApiUrl.getAllHandbooks;

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