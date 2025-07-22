import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/health_certificate_appointment_note_detail/usecases/get_health_certificate_appointment_note_detail.dart';
import '../../../service_locator.dart';
import 'appointment_health_certificate_note_detail_state.dart';

class AppointmentHealthCertificateNoteDetailCubit
    extends Cubit<AppointmentHealthCertificateNoteDetailState> {
  AppointmentHealthCertificateNoteDetailCubit()
    : super(const AppointmentHealthCertificateNoteDetailState());

  Future<void> fetchAppointmentDetail(int appointmentDetailId) async {
    emit(
      state.copyWith(status: AppointmentHealthCertificateNoteDetailStatus.loading),
    );

    try {
      final result = await sl<GetHealthCertificateAppointmentNoteDetailUseCase>().call(
        params: appointmentDetailId,
      );

      emit(
        state.copyWith(
          status: AppointmentHealthCertificateNoteDetailStatus.success,
          appointmentDetail: result,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AppointmentHealthCertificateNoteDetailStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
