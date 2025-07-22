import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../../../data/health_certificate_appointment_note_detail/models/put_health_certificate_appointment_note.dart';
import '../../../domain/health_certificate_appointment_note_detail/usecases/put_health_certificate_appointment_note.dart';
import '../../../service_locator.dart';
import 'appointment_health_certificate_note_detail_edit_state.dart';

class AppointmentHealthCertificateNoteDetailEditCubit
    extends Cubit<AppointmentHealthCertificateNoteDetailEditState> {
  AppointmentHealthCertificateNoteDetailEditCubit()
    : super(const AppointmentHealthCertificateNoteDetailEditState());

  void initializeWithData({
    required int appointmentId,
    required int customerId,
    required int petId,
    required String appointmentDate,
    required int serviceType,
    required int location,
    required String address,
  }) {
    emit(
      state.copyWith(
        appointmentId: appointmentId,
        customerId: customerId,
        petId: petId,
        appointmentDate: appointmentDate,
        serviceType: serviceType,
        location: location,
        address: address,
        isFormValid: _validateForm(
          appointmentDate: appointmentDate,
          address: address,
          location: location,
        ),
      ),
    );
  }

  void updateAppointmentDate(String date) {
    emit(
      state.copyWith(
        appointmentDate: date,
        isFormValid: _validateForm(
          appointmentDate: date,
          address: state.address,
          location: state.location,
        ),
      ),
    );
  }

  void updateServiceType(int serviceType) {
    emit(state.copyWith(serviceType: serviceType));
  }

  void updateLocation(int location) {
    emit(
      state.copyWith(
        location: location,
        isFormValid: _validateForm(
          appointmentDate: state.appointmentDate,
          address: state.address,
          location: location,
        ),
      ),
    );
  }

  void updateAddress(String address) {
    emit(
      state.copyWith(
        address: address,
        isFormValid: _validateForm(
          appointmentDate: state.appointmentDate,
          address: address,
          location: state.location,
        ),
      ),
    );
  }

  bool _validateForm({
    required String appointmentDate,
    required String address,
    required int location,
  }) {
    bool isDateValid = appointmentDate.isNotEmpty;
    bool isAddressValid = location == 1 || address.trim().isNotEmpty;
    return isDateValid && isAddressValid;
  }

  Future<void> updateAppointment() async {
    if (!state.isFormValid) return;

    emit(state.copyWith(status: AppointmentHealthCertificateNoteDetailEditStatus.loading));

    try {
      final putModel = PutHealthCertificateAppointmentModel(
        appointmentId: state.appointmentId,
        customerId: state.customerId,
        petId: state.petId,
        appointmentDate: state.appointmentDate,
        serviceType: state.serviceType,
        location: state.location,
        address: state.address,
      );

      final result = await sl<PutHealthCertificateAppointmentNoteUseCase>().call(
        params: putModel,
      );

      result.fold(
        (error) {
          emit(
            state.copyWith(
              status: AppointmentHealthCertificateNoteDetailEditStatus.failure,
              errorMessage: error.toString(),
            ),
          );
        },
        (success) {
          emit(
            state.copyWith(
              status: AppointmentHealthCertificateNoteDetailEditStatus.success,
            ),
          );
        },
      );
    } catch (e) {
      debugPrint('Update appointment error: $e');
      emit(
        state.copyWith(
          status: AppointmentHealthCertificateNoteDetailEditStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void resetStatus() {
    emit(state.copyWith(status: AppointmentHealthCertificateNoteDetailEditStatus.initial));
  }
}
