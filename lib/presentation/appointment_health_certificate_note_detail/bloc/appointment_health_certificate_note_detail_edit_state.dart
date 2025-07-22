import 'package:equatable/equatable.dart';

enum AppointmentHealthCertificateNoteDetailEditStatus {
  initial,
  loading,
  success,
  failure,
}

class AppointmentHealthCertificateNoteDetailEditState extends Equatable {
  final AppointmentHealthCertificateNoteDetailEditStatus status;
  final int appointmentId;
  final int customerId;
  final int petId;
  final String appointmentDate;
  final int serviceType;
  final int location;
  final String address;
  final bool isFormValid;
  final String? errorMessage;

  const AppointmentHealthCertificateNoteDetailEditState({
    this.status = AppointmentHealthCertificateNoteDetailEditStatus.initial,
    this.appointmentId = 0,
    this.customerId = 0,
    this.petId = 0,
    this.appointmentDate = '',
    this.serviceType = 3, // Health certificate service type
    this.location = 1,
    this.address = '',
    this.isFormValid = false,
    this.errorMessage,
  });

  AppointmentHealthCertificateNoteDetailEditState copyWith({
    AppointmentHealthCertificateNoteDetailEditStatus? status,
    int? appointmentId,
    int? customerId,
    int? petId,
    String? appointmentDate,
    int? serviceType,
    int? location,
    String? address,
    bool? isFormValid,
    String? errorMessage,
  }) {
    return AppointmentHealthCertificateNoteDetailEditState(
      status: status ?? this.status,
      appointmentId: appointmentId ?? this.appointmentId,
      customerId: customerId ?? this.customerId,
      petId: petId ?? this.petId,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      serviceType: serviceType ?? this.serviceType,
      location: location ?? this.location,
      address: address ?? this.address,
      isFormValid: isFormValid ?? this.isFormValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        appointmentId,
        customerId,
        petId,
        appointmentDate,
        serviceType,
        location,
        address,
        isFormValid,
        errorMessage,
      ];
}
