import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../repositories/appointment.dart';

class GetAppointmentsByCustomerAndStatus
    extends UseCase<Either, Map<String, dynamic>> {
  @override
  Future<Either> call({Map<String, dynamic>? params}) {
    return sl<AppointmentRepository>().getAppointmentByCustomerAndStatus(
      params?['customerId'],
      params?['status'],
    );
  }
}
