class FutureAppointmentEntity {
  final int appointmentId;
  final int customerId;
  final int petId;
  final String appointmentCode;
  final String appointmentDate;
  final int serviceType;
  final int locationType;
  final String address;
  final int appointmentStatus;
  final String customerName;
  final String petName;
  final String petSpecies;
  final String petGender;
  final String petImage;

  FutureAppointmentEntity({
    required this.appointmentId,
    required this.customerId,
    required this.petId,
    required this.appointmentCode,
    required this.appointmentDate,
    required this.serviceType,
    required this.locationType,
    required this.address,
    required this.appointmentStatus,
    required this.customerName,
    required this.petName,
    required this.petSpecies,
    required this.petGender,
    required this.petImage,
  });
}
