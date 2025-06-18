import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:vaxpet/data/auth/models/verify_email_req_params.dart';
import 'package:vaxpet/data/auth/models/verify_otp_req_params.dart';

import '../../../core/constant/api_url.dart';
import '../../../core/network/dio_client.dart';
import '../../../service_locator.dart';
import '../models/register_req_params.dart';
import '../models/signin_req_params.dart';

abstract class AuthService {
  Future<Either> register(RegisterReqParams params);
  Future<Either> signin(SigninReqParams params);
  Future<Either> verifyEmail(VerifyEmailReqParams params);
  Future<Either> verifyOtp(VerifyOtpReqParams params);
  Future<Either> getCustomerId(int accountId);
}

class AuthServiceImpl extends AuthService {
  @override
  Future<Either> register(RegisterReqParams params) async {
    try {
      var response = await sl<DioClient>().post(
        ApiUrl.register,
        data: params.toMap(),
      );
      return Right(response.data);
    } on DioException catch (e) {
      // Xử lý lỗi một cách chi tiết hơn
      if (e.response != null) {
        // Nếu server trả về response với data
        if (e.response!.data is Map && e.response!.data.containsKey('message')) {
          // Trả về thông báo lỗi từ API
          return Left(e.response!.data['message']);
        } else {
          return Left('Lỗi đăng ký: ${e.response!.statusCode}');
        }
      } else {
        // Nếu không có resp
        return Left('Lỗi kết nối: ${e.message}');
      }
    } catch (e) {
      return Left('Lỗi không xác định: $e');
    }
  }

  @override
  Future<Either> signin(SigninReqParams params) async {
    try {
      var response = await sl<DioClient>().post(
          ApiUrl.login,
          data: params.toMap()
      );
      return Right(response.data);
    } on DioException catch (e) {
      // Xử lý lỗi một cách chi tiết hơn
      if (e.response != null) {
        // Nếu server trả về response với data
        if (e.response!.data is Map && e.response!.data.containsKey('message')) {
          // Trả về thông báo lỗi từ API
          return Left(e.response!.data['message']);
        } else {
          return Left('Lỗi đăng ký: ${e.response!.statusCode}');
        }
      } else {
        // Nếu không có resp
        return Left('Lỗi kết nối: ${e.message}');
      }
    } catch (e) {
      return Left('Lỗi không xác định: $e');
    }
  }

  @override
  Future<Either> verifyEmail(VerifyEmailReqParams params) async {
    try {
      var response = await sl<DioClient>().post(
        ApiUrl.verifyEmail,
        data: params.toMap(),
      );

      return Right(response.data);
    } on DioException catch (e) {
      // Xử lý lỗi một cách chi tiết hơn
      if (e.response != null) {
        // Nếu server trả về response với data
        if (e.response!.data is Map && e.response!.data.containsKey('message')) {
          // Trả về thông báo lỗi từ API
          return Left(e.response!.data['message']);
        } else {
          return Left('Lỗi đăng ký: ${e.response!.statusCode}');
        }
      } else {
        // Nếu không có resp
        return Left('Lỗi kết nối: ${e.message}');
      }
    } catch (e) {
      return Left('Lỗi không xác định: $e');
    }
  }

  @override
  Future<Either> verifyOtp(VerifyOtpReqParams params) async {
    try {
      var response = await sl<DioClient>().post(
        ApiUrl.verifyOtp,
        data: params.toMap(),
      );

      return Right(response.data);
    } on DioException catch (e) {
      // Xử lý lỗi một cách chi tiết hơn
      if (e.response != null) {
        // Nếu server trả về response với data
        if (e.response!.data is Map && e.response!.data.containsKey('message')) {
          // Trả về thông báo lỗi từ API
          return Left(e.response!.data['message']);
        } else {
          return Left('Lỗi đăng ký: ${e.response!.statusCode}');
        }
      } else {
        // Nếu không có resp
        return Left('Lỗi kết nối: ${e.message}');
      }
    } catch (e) {
      return Left('Lỗi không xác định: $e');
    }
  }

  @override
  Future<Either> getCustomerId(int accountId) async {
    try {
      var response = await sl<DioClient>().get(
        '${ApiUrl.getCustomerId}/$accountId',
      );

      return Right(response.data);
    } on DioException catch (e) {
      // Xử lý lỗi một cách chi tiết hơn
      if (e.response != null) {
        // Nếu server trả về response với data
        if (e.response!.data is Map && e.response!.data.containsKey('message')) {
          // Trả về thông báo lỗi từ API
          return Left(e.response!.data['message']);
        } else {
          return Left('Lỗi lấy thông tin khách hàng: ${e.response!.statusCode}');
        }
      } else {
        // Nếu không có resp
        return Left('Lỗi kết nối: ${e.message}');
      }
    } catch (e) {
      return Left('Lỗi không xác định: $e');
    }

  }

}