import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../../../data/microchip_appointment_note_detail/models/put_microchip_appointment_note.dart';
import '../../../domain/microchip_appointment_note_detail/usecases/put_microchip_appointment_note.dart';
import '../../../service_locator.dart';
import 'appointment_microchip_note_detail_edit_state.dart';

class AppointmentMicrochipNoteDetailEditCubit
    extends Cubit<AppointmentMicrochipNoteDetailEditState> {
  AppointmentMicrochipNoteDetailEditCubit()
    : super(const AppointmentMicrochipNoteDetailEditState());

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

  Future<void> updateAppointment() async {
    if (!state.canSubmit) {
      emit(
        state.copyWith(
          status: AppointmentMicrochipNoteDetailEditStatus.failure,
          errorMessage: 'Vui lòng điền đầy đủ thông tin bắt buộc',
        ),
      );
      return;
    }

    // Validate address only if location is 2 (Tại nhà)
    if (state.location == 2 && (state.address.trim().isEmpty)) {
      emit(
        state.copyWith(
          status: AppointmentMicrochipNoteDetailEditStatus.failure,
          errorMessage: 'Vui lòng nhập địa chỉ khi chọn dịch vụ tại nhà',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: AppointmentMicrochipNoteDetailEditStatus.loading,
      ),
    );

    try {
      final updateModel = PutMicrochipAppointmentModel(
        appointmentId: state.appointmentId,
        customerId: state.customerId,
        petId: state.petId,
        appointmentDate: state.appointmentDate,
        serviceType: 2, // Always 2 for microchip service
        location: state.location,
        address:
            state.location == 1
                ? null
                : state.address.trim(), // Center = null, At home = address
      );

      // Debug log JSON to send
      debugPrint('Microchip appointment JSON to send: ${updateModel.toJson()}');

      final result = await sl<PutMicrochipAppointmentNoteUseCase>().call(
        params: updateModel,
      );

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: AppointmentMicrochipNoteDetailEditStatus.failure,
              errorMessage: _getErrorMessage(failure),
            ),
          );
        },
        (success) {
          emit(
            state.copyWith(
              status: AppointmentMicrochipNoteDetailEditStatus.success,
              errorMessage: null,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AppointmentMicrochipNoteDetailEditStatus.failure,
          errorMessage: 'Có lỗi xảy ra khi cập nhật lịch hẹn: ${e.toString()}',
        ),
      );
    }
  }

  bool _validateForm({
    String? appointmentDate,
    required String address,
    required int location,
  }) {
    return appointmentDate != null &&
        appointmentDate.isNotEmpty &&
        (location == 1 || address.isNotEmpty);
  }

  String _getErrorMessage(dynamic failure) {
    // Handle different types of failures
    if (failure.toString().contains('network')) {
      return 'Lỗi kết nối mạng. Vui lòng thử lại.';
    } else if (failure.toString().contains('timeout')) {
      return 'Quá thời gian chờ. Vui lòng thử lại.';
    } else if (failure.toString().contains('unauthorized')) {
      return 'Không có quyền truy cập. Vui lòng đăng nhập lại.';
    } else if (failure.toString().contains('validation')) {
      return 'Dữ liệu không hợp lệ. Vui lòng kiểm tra lại.';
    } else {
      return 'Có lỗi xảy ra khi cập nhật lịch hẹn. Vui lòng thử lại.';
    }
  }

  void resetState() {
    emit(const AppointmentMicrochipNoteDetailEditState());
  }
}
