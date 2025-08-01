import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/constant/api_url.dart';
import '../../../core/network/dio_client.dart';
import '../../../service_locator.dart';

abstract class VoucherService {
  // Get
  Future<Either> getAllVouchers(Map<String, dynamic>? params);
  Future<Either> getCustomerVoucher(int customerId);
  // Post
  Future<Either> postVoucher(int customerId, int voucherId);
}

class VoucherServiceImpl extends VoucherService {
  @override
  Future<Either> getAllVouchers(Map<String, dynamic>? params) async {
    try {
      final url = ApiUrl.getAllVoucher;

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
  Future<Either> getCustomerVoucher(int customerId) async {
    try {
      final url = '${ApiUrl.getCustomerVoucher}/$customerId';

      final response = await sl<DioClient>().get(url);

      return Right(response.data);
    } on DioException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Exception('An unexpected error occurred'));
    }
  }

  @override
  Future<Either> postVoucher(int customerId, int voucherId) async {
    try {
      final url = '${ApiUrl.postVoucher}/$customerId/$voucherId';

      final response = await sl<DioClient>().post(url);

      return Right(response.data);
    } on DioException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Exception('An unexpected error occurred'));
    }
  }
  
}