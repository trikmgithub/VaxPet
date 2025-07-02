class UpdateAppointmentModel {
  final int? appointmentId;
  final int? customerId;
  final int? petId;
  final String? appointmentDate;
  final int? serviceType;
  final int? location;
  final String? address;
  final int? diseaseId;

  UpdateAppointmentModel({
    this.appointmentId,
    this.customerId,
    this.petId,
    this.appointmentDate,
    this.serviceType,
    this.location,
    this.address,
    this.diseaseId,
  });

  Map<dynamic, dynamic> toJson() {
    return {
      "appointment": {
        "customerId": customerId,
        "petId": petId,
        "appointmentDate": appointmentDate,
        "serviceType": 1, // Luôn là 1 (tiêm chủng)
        "location": location,
        "address": location == 1 ? null : address, // Trung tâm = null, Tại nhà = address
      },
      "updateDiseaseForAppointmentDTO": {
        "diseaseId": diseaseId,
      }
    };
  }
}