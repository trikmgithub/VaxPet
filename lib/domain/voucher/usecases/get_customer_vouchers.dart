import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../repositories/voucher.dart';

class GetCustomerVouchersUseCase extends UseCase<Either, int> {
  @override
  Future<Either> call({int? params}) async {
    return await sl<VoucherRepository>().getCustomerVoucher(params!);
  }

}