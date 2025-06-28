import 'package:dartz/dartz.dart';

import '../../../data/appointment_microchip/models/post_appointment_micrcochip.dart';

abstract class AppointmentMicrochipRepository {
  //Get
  //Post
  Future<Either> postAppointmentMicrochip(PostAppointmentMicrochipModel params);
}