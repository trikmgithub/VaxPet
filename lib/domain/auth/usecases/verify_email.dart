import 'package:dartz/dartz.dart';
import 'package:vaxpet/data/auth/models/verify_email_req_params.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../repositories/auth.dart';

class VerifyEmailUseCase extends UseCase<Either, VerifyEmailReqParams> {
  @override
  Future<Either> call({VerifyEmailReqParams? params}) async {
    return await sl<AuthRepository>().verifyEmail(params!);
  }
}