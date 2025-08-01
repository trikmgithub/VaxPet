import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../repositories/sample_schedule_pet.dart';

class GetSampleSchedulePetUseCase extends UseCase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return await sl<SampleSchedulePetRepository>().getSampleSchedulePet(params!);
  }

}