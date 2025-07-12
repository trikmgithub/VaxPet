import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../repositories/auth.dart';

class ChangePasswordUseCase extends UseCase<Either, Map<String, dynamic>> {
  @override
  Future<Either> call({Map<String, dynamic>? params}) async {
    return await sl<AuthRepository>().changePassword(
      params!['email'],
      params['oldPassword'],
      params['newPassword'],
    );
  }
}