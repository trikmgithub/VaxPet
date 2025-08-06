import 'package:dartz/dartz.dart';

import '../../../domain/tips_pet/repositories/tips_pet.dart';
import '../../../domain/voucher/repositories/voucher.dart';
import '../../../service_locator.dart';
import '../sources/tips_pet.dart';

class TipsPetRepositoryImpl extends TipsPetRepository {
  @override
  Future<Either> getAllHandbooks(Map<String, dynamic>? params) async {
    var returnedData = await sl<TipsPetService>().getAllHandbooks(params);

    return returnedData.fold(
      (error) => Left(Exception(error.toString())),
      (data) {
        var allVouchers = data;
        return Right(allVouchers);
      },
    );
  }
}
