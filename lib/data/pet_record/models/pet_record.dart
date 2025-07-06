import '../../../domain/pet_record/entities/pet_record.dart';

class PetRecordModel {
  final int diseaseId;
  final String diseaseName;
  final List<VaccineDoseModel> doses;

  PetRecordModel({
    required this.diseaseId,
    required this.diseaseName,
    required this.doses,
  });

  factory PetRecordModel.fromJson(Map<String, dynamic> json) {
    return PetRecordModel(
      diseaseId: (json['diseaseId'] as num).toInt(),
      diseaseName: json['diseaseName'] as String,
      doses:
          (json['doses'] as List)
              .map((dose) => VaccineDoseModel.fromJson(dose))
              .toList(),
    );
  }

  PetRecordEntity toEntity() {
    return PetRecordEntity(
      diseaseId: diseaseId,
      diseaseName: diseaseName,
      doses: doses.map((dose) => dose.toEntity()).toList(),
    );
  }
}

class VaccineDoseModel {
  final int vaccineProfileId;
  final int petId;
  final int? appointmentDetailId;
  final int vaccinationScheduleId;
  final int diseaseId;
  final String preferedDate;
  final String? vaccinationDate;
  final int dose;
  final String? reaction;
  final String? nextVaccinationInfo;
  final bool? isActive;
  final bool isCompleted;
  final String createdAt;
  final AppointmentDetailModel? appointmentDetail;
  final DiseaseModel disease;

  VaccineDoseModel({
    required this.vaccineProfileId,
    required this.petId,
    this.appointmentDetailId,
    required this.vaccinationScheduleId,
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

  factory VaccineDoseModel.fromJson(Map<String, dynamic> json) {
    return VaccineDoseModel(
      vaccineProfileId: (json['vaccineProfileId'] as num).toInt(),
      petId: (json['petId'] as num).toInt(),
      appointmentDetailId:
          json['appointmentDetailId'] != null
              ? (json['appointmentDetailId'] as num).toInt()
              : null,
      vaccinationScheduleId: (json['vaccinationScheduleId'] as num).toInt(),
      diseaseId: (json['diseaseId'] as num).toInt(),
      preferedDate: json['preferedDate'] as String,
      vaccinationDate: json['vaccinationDate'] as String?,
      dose: (json['dose'] as num).toInt(),
      reaction: json['reaction'] as String?,
      nextVaccinationInfo: json['nextVaccinationInfo'] as String?,
      isActive: json['isActive'] as bool?,
      isCompleted: json['isCompleted'] as bool,
      createdAt: json['createdAt'] as String,
      appointmentDetail:
          json['appointmentDetail'] != null
              ? AppointmentDetailModel.fromJson(json['appointmentDetail'])
              : null,
      disease: DiseaseModel.fromJson(json['disease']),
    );
  }

  VaccineDoseEntity toEntity() {
    return VaccineDoseEntity(
      vaccineProfileId: vaccineProfileId,
      petId: petId,
      appointmentDetailId: appointmentDetailId,
      vaccinationScheduleId: vaccinationScheduleId,
      diseaseId: diseaseId,
      preferedDate: preferedDate,
      vaccinationDate: vaccinationDate,
      dose: dose,
      reaction: reaction,
      nextVaccinationInfo: nextVaccinationInfo,
      isActive: isActive,
      isCompleted: isCompleted,
      createdAt: createdAt,
      appointmentDetail: appointmentDetail?.toEntity(),
      disease: disease.toEntity(),
    );
  }
}

class AppointmentDetailModel {
  final String appointmentDetailCode;
  final int vetId;
  final int serviceType;
  final int vaccineBatchId;
  final String appointmentDate;
  final int appointmentStatus;
  final String temperature;
  final String heartRate;
  final String generalCondition;
  final String others;
  final String notes;
  final VetModel vet;
  final VaccineBatchModel vaccineBatch;

  AppointmentDetailModel({
    required this.appointmentDetailCode,
    required this.vetId,
    required this.serviceType,
    required this.vaccineBatchId,
    required this.appointmentDate,
    required this.appointmentStatus,
    required this.temperature,
    required this.heartRate,
    required this.generalCondition,
    required this.others,
    required this.notes,
    required this.vet,
    required this.vaccineBatch,
  });

  factory AppointmentDetailModel.fromJson(Map<String, dynamic> json) {
    return AppointmentDetailModel(
      appointmentDetailCode: json['appointmentDetailCode'] as String,
      vetId: (json['vetId'] as num).toInt(),
      serviceType: (json['serviceType'] as num).toInt(),
      vaccineBatchId: (json['vaccineBatchId'] as num).toInt(),
      appointmentDate: json['appointmentDate'] as String,
      appointmentStatus: (json['appointmentStatus'] as num).toInt(),
      temperature: json['temperature'] as String,
      heartRate: json['heartRate'] as String,
      generalCondition: json['generalCondition'] as String,
      others: json['others'] as String,
      notes: json['notes'] as String,
      vet: VetModel.fromJson(json['vet']),
      vaccineBatch: VaccineBatchModel.fromJson(json['vaccineBatch']),
    );
  }

  AppointmentDetailEntity toEntity() {
    return AppointmentDetailEntity(
      appointmentDetailCode: appointmentDetailCode,
      vetId: vetId,
      serviceType: serviceType,
      vaccineBatchId: vaccineBatchId,
      appointmentDate: appointmentDate,
      appointmentStatus: appointmentStatus,
      temperature: temperature,
      heartRate: heartRate,
      generalCondition: generalCondition,
      others: others,
      notes: notes,
      vet: vet.toEntity(),
      vaccineBatch: vaccineBatch.toEntity(),
    );
  }
}

class VetModel {
  final String vetCode;
  final String? name;
  final String? specialization;

  VetModel({required this.vetCode, this.name, this.specialization});

  factory VetModel.fromJson(Map<String, dynamic> json) {
    return VetModel(
      vetCode: json['vetCode'] as String,
      name: json['name'] as String?,
      specialization: json['specialization'] as String?,
    );
  }

  VetEntity toEntity() {
    return VetEntity(
      vetCode: vetCode,
      name: name,
      specialization: specialization,
    );
  }
}

class VaccineBatchModel {
  final String batchNumber;
  final String manufactureDate;
  final String expiryDate;
  final int quantity;
  final int vaccineId;
  final VaccineModel vaccine;

  VaccineBatchModel({
    required this.batchNumber,
    required this.manufactureDate,
    required this.expiryDate,
    required this.quantity,
    required this.vaccineId,
    required this.vaccine,
  });

  factory VaccineBatchModel.fromJson(Map<String, dynamic> json) {
    return VaccineBatchModel(
      batchNumber: json['batchNumber'] as String,
      manufactureDate: json['manufactureDate'] as String,
      expiryDate: json['expiryDate'] as String,
      quantity: (json['quantity'] as num).toInt(),
      vaccineId: (json['vaccineId'] as num).toInt(),
      vaccine: VaccineModel.fromJson(json['vaccine']),
    );
  }

  VaccineBatchEntity toEntity() {
    return VaccineBatchEntity(
      batchNumber: batchNumber,
      manufactureDate: manufactureDate,
      expiryDate: expiryDate,
      quantity: quantity,
      vaccineId: vaccineId,
      vaccine: vaccine.toEntity(),
    );
  }
}

class VaccineModel {
  final String vaccineCode;
  final String name;
  final String description;
  final int price;
  final String image;
  final String notes;

  VaccineModel({
    required this.vaccineCode,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.notes,
  });

  factory VaccineModel.fromJson(Map<String, dynamic> json) {
    return VaccineModel(
      vaccineCode: json['vaccineCode'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toInt(),
      image: json['image'] as String,
      notes: json['notes'] as String,
    );
  }

  VaccineEntity toEntity() {
    return VaccineEntity(
      vaccineCode: vaccineCode,
      name: name,
      description: description,
      price: price,
      image: image,
      notes: notes,
    );
  }
}

class DiseaseModel {
  final String diseaseName;

  DiseaseModel({required this.diseaseName});

  factory DiseaseModel.fromJson(Map<String, dynamic> json) {
    return DiseaseModel(diseaseName: json['diseaseName'] as String);
  }

  DiseaseEntity toEntity() {
    return DiseaseEntity(diseaseName: diseaseName);
  }
}
