import 'package:dartz/dartz.dart';

import '../../../domain/appointment/repositories/appointment.dart';
import '../../../service_locator.dart';
import '../sources/appointment.dart';

class AppointmentRepositoryImpl extends AppointmentRepository {
  @override
  Future<Either> getAppointmentByCustomerAndStatus(
    int customerId,
    String status,
  ) async {
    var returnedData = await sl<AppointmentService>()
        .getAppointmentByCustomerAndStatus(customerId, status);

    return returnedData.fold((error) => Left(Exception(error.toString())), (
      data,
    ) {
      var appointments = data;
      return Right(appointments);
    });
  }

  @override
  Future<Either> getAppointmentById(int appointmentId) async {
    var returnedData = await sl<AppointmentService>().getAppointmentById(
      appointmentId,
    );

    return returnedData.fold((error) => Left(Exception(error.toString())), (
      data,
    ) {
      var appointmentDetail = data;
      return Right(appointmentDetail);
    });
  }
}
