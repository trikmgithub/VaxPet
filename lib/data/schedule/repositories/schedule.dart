import 'package:dartz/dartz.dart';
import 'package:vaxpet/data/schedule/models/create_app_vac_req_params.dart';
import 'package:vaxpet/domain/schedule/repositories/schedule.dart';

import '../../../service_locator.dart';
import '../sources/schedule.dart';

class ScheduleRepositoryImpl extends ScheduleRepository {
  @override
  Future<Either> createAppointmentVaccinationHome(CreateAppVacReqParams params) async {
    var returnedData = await sl<ScheduleService>().createAppointmentVaccinationHome(params);
    return returnedData.fold(
      (error) => Left(Exception(error.toString())),
      (data) {
        return Right(data);
      },
    );
  }

}