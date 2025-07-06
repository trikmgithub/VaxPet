import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../data/appointment/models/update_appointment.dart';
import '../../../service_locator.dart';
import '../repositories/appointment.dart';

class PutAppointmentByIdUseCase
    extends UseCase<Either, UpdateAppointmentModel> {
  @override
  Future<Either> call({UpdateAppointmentModel? params}) {
    return sl<AppointmentRepository>().putAppointmentById(params!);
  }
}
