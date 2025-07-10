import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/appointment_vaccination/usecases/cancel_appointment_vaccination.dart';
import '../../../service_locator.dart';
import 'appointment_vaccination_note_cancel_state.dart';

class AppointmentVaccinationNoteCancelCubit extends Cubit<AppointmentVaccinationNoteCancelState> {
  AppointmentVaccinationNoteCancelCubit() : super(const AppointmentVaccinationNoteCancelState());

  Future<void> cancelAppointment(int appointmentId) async {
    try {
      emit(state.copyWith(
        status: AppointmentVaccinationNoteCancelStatus.loading,
        errorMessage: null,
        successMessage: null,
      ));

      final result = await sl<CancelAppointmentVaccinationUseCase>().call(
        params: appointmentId,
      );

      result.fold(
        (failure) {
          debugPrint('Cancel appointment failed: $failure');
          emit(state.copyWith(
            status: AppointmentVaccinationNoteCancelStatus.failure,
            errorMessage: failure.toString(),
          ));
        },
        (success) {
          debugPrint('Cancel appointment successful');
          emit(state.copyWith(
            status: AppointmentVaccinationNoteCancelStatus.success,
            successMessage: 'Hủy lịch hẹn thành công',
          ));
        },
      );
    } catch (e) {
      debugPrint('Exception during cancel appointment: $e');
      emit(state.copyWith(
        status: AppointmentVaccinationNoteCancelStatus.failure,
        errorMessage: 'Có lỗi xảy ra khi hủy lịch hẹn: $e',
      ));
    }
  }

  void resetState() {
    emit(const AppointmentVaccinationNoteCancelState());
  }
}
