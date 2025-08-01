import 'package:dartz/dartz.dart';

import '../../../domain/sample_schedule_pet/repositories/sample_schedule_pet.dart';
import '../../../domain/service_history/repositories/service_history.dart';
import '../../../domain/voucher/repositories/voucher.dart';
import '../../../service_locator.dart';
import '../sources/sample_schedule_pet.dart';

class SampleSchedulePetRepositoryImpl extends SampleSchedulePetRepository {

  @override
  Future<Either> getSampleSchedulePet(String species) async {
    var returnedData = await sl<SampleSchedulePetService>().getSampleSchedulePet(species);

    return returnedData.fold(
      (error) => Left(Exception(error.toString())),
      (data) {
        var customerVoucher = data;
        return Right(customerVoucher);
      },
    );
  }
}