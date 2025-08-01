import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../repositories/voucher.dart';

class PostVoucherUseCase extends UseCase<Either, Map<String, int>> {
  @override
  Future<Either> call({Map<String, int>? params}) async {
    if (params == null || !params.containsKey('customerId') || !params.containsKey('voucherId')) {
      return Left('Missing required parameters: customerId and voucherId');
    }

    return await sl<VoucherRepository>().postVoucher(
      params['customerId']!,
      params['voucherId']!
    );
  }
}