import 'package:dartz/dartz.dart';

import '../../../domain/helps/repositories/helps.dart';
import '../../../domain/tips_pet/repositories/tips_pet.dart';
import '../../../domain/voucher/repositories/voucher.dart';
import '../../../service_locator.dart';
import '../sources/helps.dart';

class HelpsRepositoryImpl extends HelpsRepository {
  @override
  Future<Either> getSupports(Map<String, dynamic>? params) async {
    var returnedData = await sl<HelpsService>().getSupports(params);

    return returnedData.fold(
      (error) => Left(Exception(error.toString())),
      (data) {
        var allVouchers = data;
        return Right(allVouchers);
      },
    );
  }

  @override
  Future<Either> getFAQ(Map<String, dynamic>? params) async {
    var returnedData = await sl<HelpsService>().getFAQ(params);

    return returnedData.fold(
          (error) => Left(Exception(error.toString())),
          (data) {
        var allVouchers = data;
        return Right(allVouchers);
      },
    );
  }
}
