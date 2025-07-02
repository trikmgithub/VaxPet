import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../../../data/appointment/models/update_appointment.dart';
import '../../../domain/appointment/usecases/put_appointment_by_id.dart';
import '../../../domain/disease/usecases/get_disease_by_species.dart';
import '../../../service_locator.dart';
import 'appointment_vaccination_note_detail_edit_state.dart';

class AppointmentVaccinationNoteDetailEditCubit extends Cubit<AppointmentVaccinationNoteDetailEditState> {
  AppointmentVaccinationNoteDetailEditCubit() : super(const AppointmentVaccinationNoteDetailEditState());

  void initializeWithData({
    required int appointmentId,
    required int customerId,
    required int petId,
    required String appointmentDate,
    required int serviceType,
    required int location,
    required String address,
    required int diseaseId,
  }) {
    emit(state.copyWith(
      appointmentId: appointmentId,
      customerId: customerId,
      petId: petId,
      appointmentDate: appointmentDate,
      serviceType: serviceType,
      location: location,
      address: address,
      diseaseId: diseaseId,
      isFormValid: _validateForm(
        appointmentDate: appointmentDate,
        address: address,
        diseaseId: diseaseId,
      ),
    ));
  }

  Future<void> fetchDiseasesBySpecies(String species) async {
    emit(state.copyWith(status: AppointmentVaccinationNoteDetailEditStatus.loadingDiseases));

    try {
      final result = await sl<GetDiseaseBySpeciesUseCase>().call(params: species);

      result.fold(
        (failure) {
          emit(state.copyWith(
            status: AppointmentVaccinationNoteDetailEditStatus.failure,
            errorMessage: 'Không thể tải danh sách bệnh',
            diseases: [],
          ));
        },
        (success) {
          final diseases = success['data'] as List? ?? [];
          emit(state.copyWith(
            status: AppointmentVaccinationNoteDetailEditStatus.initial,
            diseases: diseases,
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        status: AppointmentVaccinationNoteDetailEditStatus.failure,
        errorMessage: 'Lỗi khi tải danh sách bệnh: ${e.toString()}',
        diseases: [],
      ));
    }
  }

  void updateAppointmentDate(String date) {
    emit(state.copyWith(
      appointmentDate: date,
      isFormValid: _validateForm(
        appointmentDate: date,
        address: state.address,
        diseaseId: state.diseaseId,
      ),
    ));
  }

  void updateServiceType(int serviceType) {
    emit(state.copyWith(serviceType: serviceType));
  }

  void updateLocation(int location) {
    emit(state.copyWith(location: location));
  }

  void updateAddress(String address) {
    emit(state.copyWith(
      address: address,
      isFormValid: _validateForm(
        appointmentDate: state.appointmentDate,
        address: address,
        diseaseId: state.diseaseId,
      ),
    ));
  }

  void updateDiseaseId(int diseaseId) {
    emit(state.copyWith(
      diseaseId: diseaseId,
      isFormValid: _validateForm(
        appointmentDate: state.appointmentDate,
        address: state.address,
        diseaseId: diseaseId,
      ),
    ));
  }

  Future<void> updateAppointment() async {

    if (!state.canSubmit) {
      emit(state.copyWith(
        status: AppointmentVaccinationNoteDetailEditStatus.failure,
        errorMessage: 'Vui lòng điền đầy đủ thông tin bắt buộc',
      ));
      return;
    }

    // Validate address only if location is 2 (Tại nhà)
    if (state.location == 2 && (state.address.trim().isEmpty)) {
      emit(state.copyWith(
        status: AppointmentVaccinationNoteDetailEditStatus.failure,
        errorMessage: 'Vui lòng nhập địa chỉ khi chọn dịch vụ tại nhà',
      ));
      return;
    }

    emit(state.copyWith(status: AppointmentVaccinationNoteDetailEditStatus.loading));

    try {
      final updateModel = UpdateAppointmentModel(
        appointmentId: state.appointmentId,
        customerId: state.customerId,
        petId: state.petId,
        appointmentDate: state.appointmentDate,
        serviceType: 1, // Luôn là 1 (tiêm chủng)
        location: state.location,
        address: state.location == 1 ? null : state.address.trim(), // Trung tâm = null, Tại nhà = address
        diseaseId: state.diseaseId,
      );

      // Debug log JSON sẽ gửi đi
      debugPrint('JSON to send: ${updateModel.toJson()}');

      final result = await sl<PutAppointmentByIdUseCase>().call(params: updateModel);

      result.fold(
        (failure) {
          emit(state.copyWith(
            status: AppointmentVaccinationNoteDetailEditStatus.failure,
            errorMessage: _getErrorMessage(failure),
          ));
        },
        (success) {
          emit(state.copyWith(
            status: AppointmentVaccinationNoteDetailEditStatus.success,
            errorMessage: null,
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        status: AppointmentVaccinationNoteDetailEditStatus.failure,
        errorMessage: 'Có lỗi xảy ra khi cập nhật: ${e.toString()}',
      ));
    }
  }

  bool _validateForm({
    required String? appointmentDate,
    required String address,
    required int? diseaseId,
  }) {
    // Chỉ validate address nếu location = 2 (Tại nhà)
    final addressValid = state.location == 1 || address.isNotEmpty;

    return appointmentDate != null &&
           appointmentDate.isNotEmpty &&
           addressValid &&
           diseaseId != null;
  }

  String _getErrorMessage(dynamic failure) {
    if (failure is Exception) {
      final message = failure.toString();
      if (message.contains('Network')) {
        return 'Lỗi kết nối mạng. Vui lòng kiểm tra kết nối internet.';
      } else if (message.contains('400')) {
        return 'Thông tin không hợp lệ. Vui lòng kiểm tra lại.';
      } else if (message.contains('401')) {
        return 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.';
      } else if (message.contains('403')) {
        return 'Bạn không có quyền thực hiện thao tác này.';
      } else if (message.contains('404')) {
        return 'Không tìm thấy lịch hẹn cần cập nhật.';
      } else if (message.contains('500')) {
        return 'Lỗi máy chủ. Vui lòng thử lại sau.';
      }
    }
    return 'Không thể cập nhật lịch hẹn. Vui lòng thử lại.';
  }

  void clearError() {
    if (state.status == AppointmentVaccinationNoteDetailEditStatus.failure) {
      emit(state.copyWith(
        status: AppointmentVaccinationNoteDetailEditStatus.initial,
        errorMessage: null,
      ));
    }
  }

  void resetForm() {
    emit(const AppointmentVaccinationNoteDetailEditState());
  }
}
