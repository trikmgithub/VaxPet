import 'package:dartz/dartz.dart';
import 'package:vaxpet/data/auth/models/verify_otp_req_params.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../repositories/auth.dart';

class ForgotPasswordUseCase extends UseCase<Either, Map<dynamic, dynamic>> {
  @override
  Future<Either> call({Map<dynamic, dynamic>? params}) async {
    return await sl<AuthRepository>().forgotPassword(
      params!['email'],
      params['otp'],
      params['newPassword'],
    );
  }
}
