import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../repositories/voucher.dart';

class GetAllVouchersUseCase extends UseCase<Either, Map<String, dynamic>?> {
  @override
  Future<Either> call({Map<String, dynamic>? params}) async {
    return await sl<VoucherRepository>().getAllVouchers(params!);
  }

}