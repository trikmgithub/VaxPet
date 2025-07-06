import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../repositories/auth.dart';

class GetCustomerIdUseCase extends UseCase<Either, int> {
  @override
  Future<Either> call({int? params}) {
    return sl<AuthRepository>().getCustomerId(params!);
  }
}
