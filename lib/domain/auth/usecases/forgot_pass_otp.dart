import 'package:dartz/dartz.dart';
import 'package:vaxpet/data/auth/models/verify_otp_req_params.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../repositories/auth.dart';

class VerifyOtpUseCase extends UseCase<Either, VerifyOtpReqParams> {
  @override
  Future<Either> call({VerifyOtpReqParams? params}) async {
    return await sl<AuthRepository>().verifyOtp(params!);
  }
}
