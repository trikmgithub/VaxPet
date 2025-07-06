class CreateAppVacReqParams {
  final int customerId;
  final int petId;
  final String appointmentDate;
  final int serviceType;
  final int location;
  final String? address;
  final int diseaseId;

  CreateAppVacReqParams({
    required this.customerId,
    required this.petId,
    required this.appointmentDate,
    required this.serviceType,
    required this.location,
    this.address,
    required this.diseaseId,
  });

  Map<String, dynamic> toMap() {
    return {
      'appointment': {
        'customerId': customerId,
        'petId': petId,
        'appointmentDate': appointmentDate,
        'serviceType': serviceType,
        'location': location,
        'address': address ?? "",
      },
      'appointmentDetailVaccination': {'diseaseId': diseaseId},
    };
  }
}
