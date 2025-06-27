import 'package:dartz/dartz.dart';
import 'package:vaxpet/core/usecase/usecase.dart';
import 'package:vaxpet/service_locator.dart';
import '../repositories/appointment.dart';

class GetTodayAppointmentByCusId extends UseCase<Either, dynamic> {
  @override
  Future<Either> call({dynamic params}) async {
    return await sl<AppointmentRepository>().getTodayAppointmentByCusId(params.customerId, params.pageNumber, params.pageSize);
  }

}