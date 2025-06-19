import 'package:dartz/dartz.dart';
import 'package:vaxpet/core/usecase/usecase.dart';
import 'package:vaxpet/data/schedule/models/create_app_vac_req_params.dart';

import '../../../service_locator.dart';
import '../repositories/schedule.dart';

class CreateAppVacUseCase extends UseCase<Either<Exception, dynamic>, CreateAppVacReqParams> {
  @override
  Future<Either<Exception, dynamic>> call({CreateAppVacReqParams? params}) {
    return sl<ScheduleRepository>().createAppointmentVaccinationHome(params!);
  }
}