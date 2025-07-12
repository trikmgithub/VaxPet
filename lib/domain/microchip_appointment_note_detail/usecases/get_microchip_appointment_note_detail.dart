import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../repositories/microchip_appointment_note_detail.dart';

class GetMicrochipAppointmentNoteDetailUseCase extends UseCase<Either, int> {
  @override
  Future<Either> call({int? params}) async {
    return await sl<MicrochipAppointmentNoteDetailRepository>()
        .getMicrochipAppointmentNoteDetail(params!);
  }
}
