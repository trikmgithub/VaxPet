import 'package:dartz/dartz.dart';
import 'package:vaxpet/core/usecase/usecase.dart';
import 'package:vaxpet/domain/vaccine_appointment_note/repositories/vaccine_appointment_note.dart';

import '../../../service_locator.dart';

class GetVaccineAppointmentNoteUseCase extends UseCase<Either, Map<String, dynamic>> {

  @override
  Future<Either> call({Map<String, dynamic>? params}) async {
    if (params == null) {
      throw ArgumentError('Parameters cannot be null for GetVaccineAppointmentNoteUseCase');
    }
    return await sl<VaccineAppointmentNoteRepository>().getVaccineAppointmentNote(params['petId'], params['status']);
  }

}