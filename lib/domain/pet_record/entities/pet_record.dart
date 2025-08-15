class PetRecordEntity {
  final int diseaseId;
  final String diseaseName;
  final List<VaccineDoseEntity> doses;

  PetRecordEntity({
    required this.diseaseId,
    required this.diseaseName,
    required this.doses,
  });
}

class VaccineDoseEntity {
  final int vaccineProfileId;
  final int petId;
  final int? appointmentDetailId;
  final int? vaccinationScheduleId; // Make nullable
  final int diseaseId;
  final String preferedDate;
  final String? vaccinationDate;
  final int dose;
  final String? reaction;
  final String? nextVaccinationInfo;
  final bool? isActive;
  final bool isCompleted;
  final String createdAt;
  final AppointmentDetailEntity? appointmentDetail;
  final DiseaseEntity disease;

  VaccineDoseEntity({
    required this.vaccineProfileId,
    required this.petId,
    this.appointmentDetailId,
    this.vaccinationScheduleId, // Remove required
    required this.diseaseId,
    required this.preferedDate,
    this.vaccinationDate,
    required this.dose,
    this.reaction,
    this.nextVaccinationInfo,
    this.isActive,
    required this.isCompleted,
    required this.createdAt,
    this.appointmentDetail,
    required this.disease,
  });
}

class AppointmentDetailEntity {
  final String appointmentDetailCode;
  final int vetId;
  final int serviceType;
  final int? vaccineBatchId; // Make nullable
  final String appointmentDate;
  final int appointmentStatus;
  final String? temperature; // Make nullable
  final String? heartRate; // Make nullable
  final String? generalCondition; // Make nullable
  final String? others; // Make nullable
  final String? notes; // Make nullable
  final VetEntity vet;
  final VaccineBatchEntity? vaccineBatch; // Make nullable

  AppointmentDetailEntity({
    required this.appointmentDetailCode,
    required this.vetId,
    required this.serviceType,
    this.vaccineBatchId, // Remove required
    required this.appointmentDate,
    required this.appointmentStatus,
    this.temperature, // Remove required
    this.heartRate, // Remove required
    this.generalCondition, // Remove required
    this.others, // Remove required
    this.notes, // Remove required
    required this.vet,
    this.vaccineBatch, // Remove required
  });
}

class VetEntity {
  final String vetCode;
  final String? name;
  final String? specialization;

  VetEntity({required this.vetCode, this.name, this.specialization});
}

class VaccineBatchEntity {
  final String batchNumber;
  final String manufactureDate;
  final String expiryDate;
  final int quantity;
  final int vaccineId;
  final VaccineEntity vaccine;

  VaccineBatchEntity({
    required this.batchNumber,
    required this.manufactureDate,
    required this.expiryDate,
    required this.quantity,
    required this.vaccineId,
    required this.vaccine,
  });
}

class VaccineEntity {
  final String vaccineCode;
  final String name;
  final String description;
  final int price;
  final String image;
  final String notes;

  VaccineEntity({
    required this.vaccineCode,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.notes,
  });
}

class DiseaseEntity {
  final String diseaseName;

  DiseaseEntity({required this.diseaseName});
}
