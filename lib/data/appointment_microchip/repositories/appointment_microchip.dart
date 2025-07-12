import 'package:dartz/dartz.dart';

import 'package:vaxpet/data/appointment_microchip/models/post_appointment_micrcochip.dart';

import '../../../domain/appointment_microchip/repositories/appointment_microchip.dart';
import '../../../service_locator.dart';
import '../sources/appointment_microchip.dart';

class AppointmentMicrochipRepositoryImpl
    extends AppointmentMicrochipRepository {
  @override
  Future<Either> postAppointmentMicrochip(
    PostAppointmentMicrochipModel params,
  ) async {
    var returnedData = await sl<AppointmentMicrochipService>()
        .postAppointmentMicrochip(params);
    return returnedData.fold((error) => Left(Exception(error.toString())), (
      data,
    ) {
      return Right(data);
    });
  }

  @override
  Future<Either> cancelAppointmentMicrochip(int appointmentId) async {
    var returnedData = await sl<AppointmentMicrochipService>()
        .cancelAppointmentMicrochip(appointmentId);
    return returnedData.fold((error) => Left(Exception(error.toString())), (
        data,
        ) {
      return Right(data);
    });
  }
}
