import 'package:dartz/dartz.dart';

import '../../../data/auth/models/verify_email_req_params.dart';
import '../../../data/auth/models/register_req_params.dart';
import '../../../data/auth/models/signin_req_params.dart';
import '../../../data/auth/models/verify_otp_req_params.dart';

abstract class AuthRepository {
  Future<Either> register(RegisterReqParams params);
  Future<Either> signin(SigninReqParams params);
  Future<Either> verifyEmail(VerifyEmailReqParams params);
  Future<Either> verifyOtp(VerifyOtpReqParams params);
  Future<Either> getCustomerId(int accountId);
  Future<bool> isLoggedIn();
  Future<Either> logout();
}