import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../data/microchip_appointment_note_detail/models/put_microchip_appointment_note.dart';
import '../../../service_locator.dart';
import '../repositories/microchip_appointment_note_detail.dart';

class PutMicrochipAppointmentNoteUseCase
    extends UseCase<Either, PutMicrochipAppointmentModel> {
  @override
  Future<Either> call({PutMicrochipAppointmentModel? params}) {
    return sl<MicrochipAppointmentNoteDetailRepository>().putMicrochipAppointmentNoteDetail(params!);
  }
}
