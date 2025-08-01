import 'package:dartz/dartz.dart';

import '../../../domain/service_history/repositories/service_history.dart';
import '../../../domain/voucher/repositories/voucher.dart';
import '../../../service_locator.dart';
import '../sources/service_history.dart';

class ServiceHistoryRepositoryImpl extends ServiceHistoryRepository {

  @override
  Future<Either> getServiceHistory(int customerId) async {
    var returnedData = await sl<ServiceHistoryService>().getServiceHistory(customerId);

    return returnedData.fold(
      (error) => Left(Exception(error.toString())),
      (data) {
        var customerVoucher = data;
        return Right(customerVoucher);
      },
    );
  }
}