import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaxpet/presentation/vaccine_appointment_note/bloc/vaccine_appointment_note_detail_state.dart';
import 'package:vaxpet/service_locator.dart';

import '../../../domain/appointment/usecases/get_appointment_by_id.dart';

class VaccineAppointmentNoteDetailCubit extends Cubit<VaccineAppointmentNoteDetailState> {
  VaccineAppointmentNoteDetailCubit() : super(const VaccineAppointmentNoteDetailState());

  Future<void> fetchAppointmentDetail(int appointmentId) async {
    emit(state.copyWith(status: VaccineAppointmentNoteDetailStatus.loading));

    try {
      final result = await sl<GetAppointmentsByIdUseCase>().call(
        params: appointmentId,
      );

      emit(
        state.copyWith(
          status: VaccineAppointmentNoteDetailStatus.success,
          appointmentDetail: result,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: VaccineAppointmentNoteDetailStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
