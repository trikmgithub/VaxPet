import 'package:dartz/dartz.dart';

abstract class AppointmentRepository {
  Future<Either> getAppointmentByCustomerAndStatus(int customerId, String status);
}