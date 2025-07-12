class PutMicrochipAppointmentEntity {
  final int? appointmentId;
  final int? customerId;
  final int? petId;
  final String? appointmentDate;
  final int? serviceType;
  final int? location;
  final String? address;

  PutMicrochipAppointmentEntity({
    this.appointmentId,
    this.customerId,
    this.petId,
    this.appointmentDate,
    this.serviceType,
    this.location,
    this.address,
  });
}
