class PutMicrochipAppointmentModel {
  final int? appointmentId;
  final int? customerId;
  final int? petId;
  final String? appointmentDate;
  final int? serviceType;
  final int? location;
  final String? address;

  PutMicrochipAppointmentModel({
    this.appointmentId,
    this.customerId,
    this.petId,
    this.appointmentDate,
    this.serviceType,
    this.location,
    this.address,
  });

  Map<dynamic, dynamic> toJson() {
    return {
      "customerId": customerId,
      "petId": petId,
      "appointmentDate": appointmentDate,
      "serviceType": serviceType ?? 2, // Mặc định là 2 cho microchip
      "location": location,
      "address":
      location == 1
          ? null
          : address, // Trung tâm = null, Tại nhà = address
    };
  }
}
