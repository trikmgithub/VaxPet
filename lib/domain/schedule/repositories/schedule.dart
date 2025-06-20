import 'package:dartz/dartz.dart';

import '../../../data/schedule/models/create_app_vac_req_params.dart';

abstract class ScheduleRepository {
  Future<Either> createAppointmentVaccinationHome(CreateAppVacReqParams params);
}