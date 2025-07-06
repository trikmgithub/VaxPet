import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../data/auth/models/register_req_params.dart';
import '../../../service_locator.dart';
import '../repositories/auth.dart';

class RegisterUseCase extends UseCase<Either, RegisterReqParams> {
  @override
  Future<Either> call({RegisterReqParams? params}) async {
    return await sl<AuthRepository>().register(params!);
  }
}
