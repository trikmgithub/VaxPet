import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaxpet/data/auth/models/verify_email_req_params.dart';

import 'package:vaxpet/data/auth/models/register_req_params.dart';

import 'package:vaxpet/data/auth/models/signin_req_params.dart';

import '../../../domain/auth/repositories/auth.dart';
import '../../../service_locator.dart';
import '../sources/auth_api_service.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<bool> isLoggedIn() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var accessToken = sharedPreferences.getString('accessToken');
    if (accessToken == null) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Future<Either> signin(SigninReqParams params) async {
    var data = await sl<AuthService>().signin(params);
    return data.fold((error) => Left(error), (data) async {
      return Right(data);
    });
  }

  @override
  Future<Either> register(RegisterReqParams params) async {
    var data = await sl<AuthService>().register(params);
    return data.fold((error) => Left(error), (data) async {
      return Right(data);
    });
  }

  @override
  Future<Either> verifyEmail(VerifyEmailReqParams params) async {
    var data = await sl<AuthService>().verifyEmail(params);
    return data.fold((error) => Left(error), (data) async {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      // Lưu thông tin token
      sharedPreferences.setString('accessToken', data['data']['accessToken']);
      sharedPreferences.setString('refreshToken', data['data']['refreshToken']);

      // Lưu thông tin người dùng
      sharedPreferences.setString('email', data['data']['email']);
      sharedPreferences.setInt('accountId', data['data']['accountId']);

      return Right(data);
    });
  }

  @override
  Future<Either> verifyOtp(params) async {
    var data = await sl<AuthService>().verifyOtp(params);
    return data.fold((error) => Left(error), (data) async {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      // Lưu thông tin token
      sharedPreferences.setString('accessToken', data['data']['accessToken']);
      sharedPreferences.setString('refreshToken', data['data']['refreshToken']);

      // Lưu thông tin người dùng
      sharedPreferences.setString('email', data['data']['email']);
      sharedPreferences.setInt('accountId', data['data']['accountId']);
      sharedPreferences.setString('userName', data['data']['fullName'] ?? '');
      sharedPreferences.setString('profileImage', data['data']['image'] ?? '');

      return Right(data);
    });
  }

  @override
  Future<Either> logout() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var logoutResult = await sl<AuthService>().logout();
    return logoutResult.fold((error) => Left(error), (data) async {
      await sharedPreferences.clear();
      return Right(data);
    });
  }

  @override
  Future<Either> getCustomerId(int accountId) async {
    var data = await sl<AuthService>().getCustomerId(accountId);
    return data.fold((error) => Left(error), (data) async {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      // Lưu thông tin người dùng
      await sharedPreferences.setInt('customerId', data['data']['customerId']);

      return Right(data);
    });
  }

  @override
  Future<Either> changePassword(String email, String oldPassword, String newPassword) async {
    var data = await sl<AuthService>().changePassword(
      email,
      oldPassword,
      newPassword,
    );
    return data.fold(
      (error) => Left(error),
      (data) async {
        return Right(data);
      }
    );
  }

  @override
  Future<Either> forgotPassOTP(String email) async {
    var data = await sl<AuthService>().forgotPassOTP(email);
    return data.fold(
      (error) => Left('Lỗi: $error'),
      (data) async {
        return Right(data);
      }
    );
  }

  @override
  Future<Either> forgotPassword(String email, String otp, String newPassword) async {
    var data = await sl<AuthService>().forgotPassword(
      email,
      otp,
      newPassword,
    );
    return data.fold(
      (error) => Left('Lỗi: $error'),
      (data) async {
        return Right(data);
      }
    );
  }
}
