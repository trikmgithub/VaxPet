import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../repositories/point_transaction.dart';

class GetPointTransactionUseCase extends UseCase<Either, int> {
  @override
  Future<Either> call({int? params}) async {
    return await sl<PointTransactionRepository>().getPointTransactionByCustomerId(params!);
  }

}