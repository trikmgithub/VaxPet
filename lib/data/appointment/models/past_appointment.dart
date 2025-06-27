class PastAppointmentModel {
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

  PastAppointmentModel({
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
    required this.petImage
  });

  factory PastAppointmentModel.fromJson(Map<dynamic, dynamic> json) {
    final customer = json['customerResponseDTO'] ?? {};
    final pet = json['petResponseDTO'] ?? {};

    return PastAppointmentModel(
      appointmentId: json['appointmentId'],
      customerId: json['customerId'],
      petId: json['petId'],
      appointmentCode: json['appointmentCode'],
      appointmentDate: json['appointmentDate'],
      serviceType: json['serviceType'],
      locationType: json['location'],
      address: json['address'],
      appointmentStatus: json['appointmentStatus'],
      customerName: customer['fullName'] ?? '',
      petName: pet['name'] ?? '',
      petSpecies: pet['species'] ?? '',
      petGender: pet['gender'] ?? '',
      petImage: pet['image'] ?? '',
    );
  }


}