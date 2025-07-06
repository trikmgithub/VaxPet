import 'package:dartz/dartz.dart';

import '../../../data/appointment/models/update_appointment.dart';

abstract class AppointmentRepository {
  //Get
  Future<Either> getAppointmentByCustomerAndStatus(
    int customerId,
    String status,
  );
  Future<Either> getAppointmentById(int appointmentId);
  Future<Either> getPastAppointmentByCusId(
    int customerId,
    int pageNumber,
    int pageSize,
  );
  Future<Either> getTodayAppointmentByCusId(
    int customerId,
    int pageNumber,
    int pageSize,
  );
  Future<Either> getFutureAppointmentByCusId(
    int customerId,
    int pageNumber,
    int pageSize,
  );
  //Post
  //Put
  Future<Either> putAppointmentById(UpdateAppointmentModel appointmentUpdate);
  //Delete
}
