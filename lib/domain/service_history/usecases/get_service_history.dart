import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../repositories/service_history.dart';

class GetServiceHistoryUseCase extends UseCase<Either, int> {
  @override
  Future<Either> call({int? params}) async {
    return await sl<ServiceHistoryRepository>().getServiceHistory(params!);
  }

}