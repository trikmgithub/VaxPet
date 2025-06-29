import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaxpet/domain/vaccine_appointment_note/usecases/get_vaccine_appointment_note.dart';
import 'package:vaxpet/presentation/appointment_vaccination_note/bloc/appointment_vaccination_note_state.dart';
import 'package:vaxpet/service_locator.dart';

class AppointmentVaccinationNoteCubit extends Cubit<AppointmentVaccinationNoteState> {
  AppointmentVaccinationNoteCubit() : super(const AppointmentVaccinationNoteState());

  // Status 1: Pending confirmation
  // Status 2: Confirmed
  Future<void> fetchAppointmentVaccinationNotes(int petId) async {
    emit(state.copyWith(status: AppointmentVaccinationNoteStatus.loading));

    try {
      // Fetch pending appointments (status 1)
      final pendingResult = await sl<GetVaccineAppointmentNoteUseCase>().call(
        params: {
          'petId': petId,
          'status': 1,
        },
      );

      // Fetch confirmed appointments (status 2)
      final confirmedResult = await sl<GetVaccineAppointmentNoteUseCase>().call(
        params: {
          'petId': petId,
          'status': 2,
        },
      );

      emit(
        state.copyWith(
          status: AppointmentVaccinationNoteStatus.success,
          pendingAppointments: pendingResult,
          confirmedAppointments: confirmedResult,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AppointmentVaccinationNoteStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  // Method to refresh appointment data
  Future<void> refreshAppointments(int petId) async {
    await fetchAppointmentVaccinationNotes(petId);
  }
}
