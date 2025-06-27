import 'package:dartz/dartz.dart';
import 'package:vaxpet/core/usecase/usecase.dart';

import '../../../service_locator.dart';
import '../repositories/appointment.dart';

class GetFutureAppointmentByCusId extends UseCase<Either, dynamic> {
  @override
  Future<Either> call({dynamic params}) async {
    return await sl<AppointmentRepository>().getFutureAppointmentByCusId(params.customerId, params.pageNumber, params.pageSize);
  }

}