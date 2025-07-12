import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/microchip_appointment_note_detail/usecases/get_microchip_appointment_note_detail.dart';
import '../../../service_locator.dart';
import 'appointment_microchip_note_detail_state.dart';

class AppointmentMicrochipNoteDetailCubit
    extends Cubit<AppointmentMicrochipNoteDetailState> {
  AppointmentMicrochipNoteDetailCubit()
    : super(const AppointmentMicrochipNoteDetailState());

  Future<void> fetchAppointmentDetail(int appointmentId) async {
    emit(
      state.copyWith(status: AppointmentMicrochipNoteDetailStatus.loading),
    );

    try {
      final result = await sl<GetMicrochipAppointmentNoteDetailUseCase>().call(
        params: appointmentId,
      );

      emit(
        state.copyWith(
          status: AppointmentMicrochipNoteDetailStatus.success,
          appointmentDetail: result,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AppointmentMicrochipNoteDetailStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
