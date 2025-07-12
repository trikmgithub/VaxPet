import 'package:dartz/dartz.dart';

import '../../../data/appointment_microchip/models/post_appointment_micrcochip.dart';

abstract class AppointmentMicrochipRepository {
  //Post
  Future<Either> postAppointmentMicrochip(PostAppointmentMicrochipModel params);
  //Put
  Future<Either> cancelAppointmentMicrochip(int appointmentId);
}
