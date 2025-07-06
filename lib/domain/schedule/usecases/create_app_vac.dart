import 'package:dartz/dartz.dart';
import 'package:vaxpet/core/usecase/usecase.dart';
import 'package:vaxpet/data/schedule/models/create_app_vac_req_params.dart';

import '../../../service_locator.dart';
import '../repositories/schedule.dart';

class CreateAppVacUseCase extends UseCase<Either, CreateAppVacReqParams> {
  @override
  Future<Either> call({CreateAppVacReqParams? params}) {
    return sl<ScheduleRepository>().createAppointmentVaccinationHome(params!);
  }
}
