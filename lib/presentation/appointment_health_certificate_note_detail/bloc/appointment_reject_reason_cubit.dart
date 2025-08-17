import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaxpet/service_locator.dart';
import '../../../domain/health_certificate_appointment_note_detail/usecases/get_health_certificate_appointment_note_more_detail.dart';
import 'appointment_reject_reason_state.dart';

class AppointmentRejectReasonCubit extends Cubit<AppointmentRejectReasonState> {
  AppointmentRejectReasonCubit() : super(const AppointmentRejectReasonState());

  final GetHealthCertificateAppointmentNoteMoreDetailUseCase _getHealthCertificateAppointmentDetailUseCase =
      sl<GetHealthCertificateAppointmentNoteMoreDetailUseCase>();

  Future<void> getAppointmentRejectReason(int appointmentId) async {
    emit(state.copyWith(status: AppointmentRejectReasonStatus.loading));

    try {
      final result = await _getHealthCertificateAppointmentDetailUseCase.call(params: appointmentId);

      result.fold(
        (failure) {
          emit(state.copyWith(
            status: AppointmentRejectReasonStatus.failure,
            errorMessage: failure.message,
          ));
        },
        (response) {
          final data = response['data'];
          final notes = data['notes'] ?? 'Không có lý do cụ thể';
          final appointmentCode = data['appointment']['appointmentCode'] ?? '';

          emit(state.copyWith(
            status: AppointmentRejectReasonStatus.success,
            rejectReason: notes,
            appointmentCode: appointmentCode,
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        status: AppointmentRejectReasonStatus.failure,
        errorMessage: 'Có lỗi xảy ra khi tải thông tin: ${e.toString()}',
      ));
    }
  }
}
