import 'package:dartz/dartz.dart';

import '../../../domain/point_transaction/repositories/point_transaction.dart';
import '../../../service_locator.dart';
import '../sources/point_transaction.dart';

class PointTransactionRepositoryImpl extends PointTransactionRepository {
  @override
  Future<Either> getPointTransactionByCustomerId(int customerId) async {
    var returnedData = await sl<PointTransactionService>().getPointTransactionByCustomerId(customerId);

    return returnedData.fold(
      (error) => Left(Exception(error.toString())),
      (data) {
        var customerPointTransaction = data;
        return Right(customerPointTransaction);
      },
    );
  }

}