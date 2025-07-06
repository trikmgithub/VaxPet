import 'package:dartz/dartz.dart';
import 'package:vaxpet/core/usecase/usecase.dart';

import '../../../data/appointment_microchip/models/post_appointment_micrcochip.dart';
import '../../../service_locator.dart';
import '../repositories/appointment_microchip.dart';

class PostAppointmentMicrochipUseCase
    extends UseCase<Either, PostAppointmentMicrochipModel> {
  @override
  Future<Either> call({PostAppointmentMicrochipModel? params}) async {
    return await sl<AppointmentMicrochipRepository>().postAppointmentMicrochip(
      params!,
    );
  }
}
