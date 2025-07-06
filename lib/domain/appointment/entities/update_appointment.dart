class UpdateAppointmentEntity {
  final int? appointmentId;
  final int? customerId;
  final int? petId;
  final String? appointmentDate;
  final int? serviceType;
  final int? location;
  final String? address;
  final int? diseaseId;

  UpdateAppointmentEntity({
    this.appointmentId,
    this.customerId,
    this.petId,
    this.appointmentDate,
    this.serviceType,
    this.location,
    this.address,
    this.diseaseId,
  });
}
