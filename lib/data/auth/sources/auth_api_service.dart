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
  Future<Either> logout();
  Future<Either> changePassword(String email, String oldPassword, String newPassword);
  Future<Either> forgotPassOTP(String email);
  Future<Either> forgotPassword(String email, String otp, String newPassword);
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
      return Left('Lỗi ${e.response?.data['message']}');
    } catch (e) {
      return Left('Lỗi không xác định: $e');
    }
  }

  @override
  Future<Either> signin(SigninReqParams params) async {
    try {
      var response = await sl<DioClient>().post(
        ApiUrl.login,
        data: params.toMap(),
      );
      return Right(response.data);
    } on DioException catch (e) {
      return Left('Lỗi ${e.response?.data['message']}');
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
      return Left('Lỗi kết nối: ${e.message}');
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
      return Left('Lỗi kết nối: ${e.message}');
    } catch (e) {
      return Left('Lỗi không xác định: $e');
    }
  }

  @override
  Future<Either> getCustomerId(int accountId) async {
    try {
      var response = await sl<DioClient>().get(
        '${ApiUrl.getCustomerByAccountId}/$accountId',
      );

      return Right(response.data);
    } on DioException catch (e) {
      return Left('Lỗi kết nối: ${e.message}');
    } catch (e) {
      return Left('Lỗi không xác định: $e');
    }
  }

  @override
  Future<Either> logout() async {
    try {
      var response = 'Logout successful';

      return Right(response);
    } on DioException catch (e) {
      return Left('Lỗi kết nối: ${e.message}');
    } catch (e) {
      return Left('Lỗi không xác định: $e');
    }
  }

  @override
  Future<Either> changePassword(String email, String oldPassword, String newPassword) async {
    try {
      // Create FormData for multipart/form-data request
      FormData formData = FormData.fromMap({
        'email': email,
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      });

      var response = await sl<DioClient>().post(
        ApiUrl.changePassword,
        data: formData,
      );

      return Right(response.data);
    } on DioException catch (e) {
      // Xử lý lỗi validation từ API
      if (e.response?.statusCode == 400 && e.response?.data != null) {
        try {
          final errorData = e.response!.data;
          if (errorData is Map<String, dynamic> && errorData.containsKey('errors')) {
            final errors = errorData['errors'] as Map<String, dynamic>;
            List<String> errorMessages = [];

            errors.forEach((field, messages) {
              if (messages is List) {
                errorMessages.addAll(messages.cast<String>());
              }
            });

            return Left(errorMessages.join('\n'));
          }

          // Nếu có title
          if (errorData.containsKey('title')) {
            return Left(errorData['title']);
          }

          // Fallback
          return Left('Yêu cầu không hợp lệ');
        } catch (parseError) {
          return Left('Lỗi không hợp lệ từ server');
        }
      }

      return Left('Lỗi kết nối: ${e.message}');
    } catch (e) {
      return Left('Lỗi không xác định: $e');
    }
  }

  @override
  Future<Either> forgotPassOTP(String email) async {
    try {
      var response = await sl<DioClient>().post(
        ApiUrl.forgotPassOTP,
        data: {'email': email},
      );

      return Right(response.data);
    } on DioException catch (e) {
      return Left('Lỗi kết nối: ${e.message}');
    } catch (e) {
      return Left('Lỗi không xác định: $e');
    }
  }

  @override
  Future<Either> forgotPassword(String email, String otp, String newPassword) async {
    try {
      var response = await sl<DioClient>().post(
        ApiUrl.forgotPassword,
        data: {
          'email': email,
          'otp': otp,
          'newPassword': newPassword,
        },
      );

      return Right(response.data);
    } on DioException catch (e) {
      return Left('Lỗi kết nối: ${e.message}');
    } catch (e) {
      return Left('Lỗi không xác định: $e');
    }
  }
}
