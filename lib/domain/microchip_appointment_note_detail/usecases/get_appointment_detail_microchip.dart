import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../repositories/microchip_appointment_note_detail.dart';

class GetAppointmentDetailMicrochipUseCase extends UseCase<Either, int> {
  @override
  Future<Either> call({int? params}) async {
    return await sl<MicrochipAppointmentNoteDetailRepository>()
        .getAppointmentDetailForMicrochipById(params!);
  }
}
