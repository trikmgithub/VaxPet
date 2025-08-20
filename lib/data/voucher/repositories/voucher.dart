import 'package:dartz/dartz.dart';

import '../../../domain/voucher/repositories/voucher.dart';
import '../../../service_locator.dart';
import '../sources/voucher.dart';

class VoucherRepositoryImpl extends VoucherRepository {
  @override
  Future<Either> getAllVouchers(Map<String, dynamic>? params) async {
    var returnedData = await sl<VoucherService>().getAllVouchers(params);

    return returnedData.fold(
      (error) => Left(error.toString()),
      (data) {
        var allVouchers = data;
        return Right(allVouchers);
      },
    );
  }

  @override
  Future<Either> getCustomerVoucher(int customerId) async {
    var returnedData = await sl<VoucherService>().getCustomerVoucher(customerId);

    return returnedData.fold(
      (error) => Left(error.toString()),
      (data) {
        var customerVoucher = data;
        return Right(customerVoucher);
      },
    );
  }

  @override
  Future<Either> postVoucher(int customerId, int voucherId) async {
    var returnedData = await sl<VoucherService>().postVoucher(customerId, voucherId);

    return returnedData.fold(
      (error) => Left(error.toString()),
      (data) {
        return Right(data);
      },
    );
  }
}
