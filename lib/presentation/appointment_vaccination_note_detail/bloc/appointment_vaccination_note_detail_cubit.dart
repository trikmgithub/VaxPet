import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/vaccine_appointment_note_detail/usecases/get_vaccine_appointment_note_detail.dart';
import '../../../service_locator.dart';
import 'appointment_vaccination_note_detail_state.dart';

class AppointmentVaccinationNoteDetailCubit
    extends Cubit<AppointmentVaccinationNoteDetailState> {
  AppointmentVaccinationNoteDetailCubit()
    : super(const AppointmentVaccinationNoteDetailState());

  Future<void> fetchAppointmentDetail(int appointmentId) async {
    emit(
      state.copyWith(status: AppointmentVaccinationNoteDetailStatus.loading),
    );

    try {
      final result = await sl<GetVaccineAppointmentNoteDetailUseCase>().call(
        params: appointmentId,
      );

      emit(
        state.copyWith(
          status: AppointmentVaccinationNoteDetailStatus.success,
          appointmentDetail: result,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AppointmentVaccinationNoteDetailStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
