import 'package:equatable/equatable.dart';

enum AppointmentVaccinationNoteDetailEditStatus {
  initial,
  loading,
  loadingDiseases,
  success,
  failure,
}

class AppointmentVaccinationNoteDetailEditState extends Equatable {
  const AppointmentVaccinationNoteDetailEditState({
    this.status = AppointmentVaccinationNoteDetailEditStatus.initial,
    this.appointmentDate,
    this.serviceType = 1,
    this.location = 1,
    this.address = '',
    this.diseaseId,
    this.diseases = const [],
    this.errorMessage,
    this.appointmentId,
    this.customerId,
    this.petId,
    this.isFormValid = false,
  });

  final AppointmentVaccinationNoteDetailEditStatus status;
  final String? appointmentDate;
  final int serviceType;
  final int location;
  final String address;
  final int? diseaseId;
  final List<dynamic> diseases;
  final String? errorMessage;
  final int? appointmentId;
  final int? customerId;
  final int? petId;
  final bool isFormValid;

  AppointmentVaccinationNoteDetailEditState copyWith({
    AppointmentVaccinationNoteDetailEditStatus? status,
    String? appointmentDate,
    int? serviceType,
    int? location,
    String? address,
    int? diseaseId,
    List<dynamic>? diseases,
    String? errorMessage,
    int? appointmentId,
    int? customerId,
    int? petId,
    bool? isFormValid,
  }) {
    return AppointmentVaccinationNoteDetailEditState(
      status: status ?? this.status,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      serviceType: serviceType ?? this.serviceType,
      location: location ?? this.location,
      address: address ?? this.address,
      diseaseId: diseaseId ?? this.diseaseId,
      diseases: diseases ?? this.diseases,
      errorMessage: errorMessage ?? this.errorMessage,
      appointmentId: appointmentId ?? this.appointmentId,
      customerId: customerId ?? this.customerId,
      petId: petId ?? this.petId,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }

  bool get canSubmit =>
      appointmentId != null &&
      customerId != null &&
      petId != null &&
      appointmentDate != null &&
      appointmentDate!.isNotEmpty &&
      (location == 1 ||
          address.isNotEmpty) && // Chỉ validate address nếu location = 2
      diseaseId != null;

  @override
  List<Object?> get props => [
    status,
    appointmentDate,
    serviceType,
    location,
    address,
    diseaseId,
    diseases,
    errorMessage,
    appointmentId,
    customerId,
    petId,
    isFormValid,
  ];
}
