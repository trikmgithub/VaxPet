import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/appointment_microchip/usecases/cancel_appointment_microchip.dart';
import '../../../service_locator.dart';
import 'appointment_microchip_note_cancel_state.dart';

class AppointmentMicrochipNoteCancelCubit extends Cubit<AppointmentMicrochipNoteCancelState> {
  AppointmentMicrochipNoteCancelCubit() : super(const AppointmentMicrochipNoteCancelState());

  Future<void> cancelAppointment(int appointmentId) async {
    try {
      emit(state.copyWith(
        status: AppointmentMicrochipNoteCancelStatus.loading,
        errorMessage: null,
        successMessage: null,
      ));

      final result = await sl<CancelAppointmentMicrochipUseCase>().call(
        params: appointmentId,
      );

      result.fold(
        (failure) {
          debugPrint('Cancel microchip appointment failed: $failure');
          emit(state.copyWith(
            status: AppointmentMicrochipNoteCancelStatus.failure,
            errorMessage: failure.toString(),
          ));
        },
        (success) {
          debugPrint('Cancel microchip appointment successful');
          emit(state.copyWith(
            status: AppointmentMicrochipNoteCancelStatus.success,
            successMessage: 'Hủy lịch hẹn cấy chip thành công',
          ));
        },
      );
    } catch (e) {
      debugPrint('Exception during cancel microchip appointment: $e');
      emit(state.copyWith(
        status: AppointmentMicrochipNoteCancelStatus.failure,
        errorMessage: 'Có lỗi xảy ra khi hủy lịch hẹn cấy chip: $e',
      ));
    }
  }

  void resetState() {
    emit(const AppointmentMicrochipNoteCancelState());
  }
}
