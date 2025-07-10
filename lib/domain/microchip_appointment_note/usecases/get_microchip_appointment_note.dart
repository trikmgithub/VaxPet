import 'package:dartz/dartz.dart';
import 'package:vaxpet/core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../repositories/microchip_appointment_note.dart';

class GetMicrochipAppointmentNoteUseCase
    extends UseCase<Either, Map<String, dynamic>> {
  @override
  Future<Either> call({Map<String, dynamic>? params}) async {
    return await sl<MicrochipAppointmentNoteRepository>()
        .getMicrochipAppointmentNote(params?['petId'], params?['status']);
  }
}
