import 'package:equatable/equatable.dart';

enum AppointmentMicrochipNoteDetailEditStatus {
  initial,
  loading,
  success,
  failure,
}

class AppointmentMicrochipNoteDetailEditState extends Equatable {
  const AppointmentMicrochipNoteDetailEditState({
    this.status = AppointmentMicrochipNoteDetailEditStatus.initial,
    this.appointmentDate,
    this.serviceType = 2, // Microchip service type
    this.location = 1,
    this.address = '',
    this.errorMessage,
    this.appointmentId,
    this.customerId,
    this.petId,
    this.isFormValid = false,
  });

  final AppointmentMicrochipNoteDetailEditStatus status;
  final String? appointmentDate;
  final int serviceType;
  final int location;
  final String address;
  final String? errorMessage;
  final int? appointmentId;
  final int? customerId;
  final int? petId;
  final bool isFormValid;

  AppointmentMicrochipNoteDetailEditState copyWith({
    AppointmentMicrochipNoteDetailEditStatus? status,
    String? appointmentDate,
    int? serviceType,
    int? location,
    String? address,
    String? errorMessage,
    int? appointmentId,
    int? customerId,
    int? petId,
    bool? isFormValid,
  }) {
    return AppointmentMicrochipNoteDetailEditState(
      status: status ?? this.status,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      serviceType: serviceType ?? this.serviceType,
      location: location ?? this.location,
      address: address ?? this.address,
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
      (location == 1 || address.isNotEmpty); // Validate address only if location = 2

  @override
  List<Object?> get props => [
    status,
    appointmentDate,
    serviceType,
    location,
    address,
    errorMessage,
    appointmentId,
    customerId,
    petId,
    isFormValid,
  ];
}
