class PostAppointmentMicrochipModel {
  final int customerId;
  final int petId;
  final String appointmentDate;
  final int serviceType;
  final int location;
  final String? address;

  PostAppointmentMicrochipModel({
    required this.customerId,
    required this.petId,
    required this.appointmentDate,
    required this.serviceType,
    required this.location,
    this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'appointment': {
        'customerId': customerId,
        'petId': petId,
        'appointmentDate': appointmentDate,
        'serviceType': serviceType,
        'location': location,
        'address': address,
      },
    };
  }


}