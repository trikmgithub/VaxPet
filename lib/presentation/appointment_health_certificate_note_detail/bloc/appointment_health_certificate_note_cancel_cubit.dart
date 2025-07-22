import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/appointment_health_certificate/usecases/cancel_appointment_health_certificate.dart';
import '../../../service_locator.dart';
import 'appointment_health_certificate_note_cancel_state.dart';

class AppointmentHealthCertificateNoteCancelCubit
    extends Cubit<AppointmentHealthCertificateNoteCancelState> {
  AppointmentHealthCertificateNoteCancelCubit()
    : super(const AppointmentHealthCertificateNoteCancelState());

  Future<void> cancelAppointment(int appointmentId) async {
    emit(
      state.copyWith(status: AppointmentHealthCertificateNoteCancelStatus.loading),
    );

    try {
      final result = await sl<CancelAppointmentHealthCertificateUseCase>().call(
        params: appointmentId,
      );

      result.fold(
        (error) {
          emit(
            state.copyWith(
              status: AppointmentHealthCertificateNoteCancelStatus.failure,
              errorMessage: error.toString(),
            ),
          );
        },
        (success) {
          emit(
            state.copyWith(
              status: AppointmentHealthCertificateNoteCancelStatus.success,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AppointmentHealthCertificateNoteCancelStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void resetStatus() {
    emit(
      state.copyWith(status: AppointmentHealthCertificateNoteCancelStatus.initial),
    );
  }
}
