abstract class SampleSchedulePetState {}

class SampleSchedulePetLoading extends SampleSchedulePetState {}

class SampleSchedulePetLoaded extends SampleSchedulePetState {
  final List<SpeciesSchedule> speciesSchedules;

  SampleSchedulePetLoaded({required this.speciesSchedules});
}

class SampleSchedulePetFailure extends SampleSchedulePetState {
  final String errorMessage;

  SampleSchedulePetFailure({required this.errorMessage});
}

// Models for the data structure
class SpeciesSchedule {
  final String species;
  final List<DiseaseSchedule> schedules;

  SpeciesSchedule({
    required this.species,
    required this.schedules,
  });

  factory SpeciesSchedule.fromJson(Map<String, dynamic> json) {
    return SpeciesSchedule(
      species: json['species'] ?? '',
      schedules: (json['schedules'] as List<dynamic>?)
          ?.map((e) => DiseaseSchedule.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

class DiseaseSchedule {
  final int diseaseId;
  final String diseaseName;
  final List<VaccinationSchedule> schedules;

  DiseaseSchedule({
    required this.diseaseId,
    required this.diseaseName,
    required this.schedules,
  });

  factory DiseaseSchedule.fromJson(Map<String, dynamic> json) {
    return DiseaseSchedule(
      diseaseId: json['diseaseId'] ?? 0,
      diseaseName: json['diseaseName'] ?? '',
      schedules: (json['schedules'] as List<dynamic>?)
          ?.map((e) => VaccinationSchedule.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

class VaccinationSchedule {
  final int vaccinationScheduleId;
  final int diseaseId;
  final String species;
  final int doseNumber;
  final int ageInterval;
  final String createdAt;
  final String createdBy;
  final String? modifiedAt;
  final String? modifiedBy;
  final Disease disease;

  VaccinationSchedule({
    required this.vaccinationScheduleId,
    required this.diseaseId,
    required this.species,
    required this.doseNumber,
    required this.ageInterval,
    required this.createdAt,
    required this.createdBy,
    this.modifiedAt,
    this.modifiedBy,
    required this.disease,
  });

  factory VaccinationSchedule.fromJson(Map<String, dynamic> json) {
    return VaccinationSchedule(
      vaccinationScheduleId: json['vaccinationScheduleId'] ?? 0,
      diseaseId: json['diseaseId'] ?? 0,
      species: json['species'] ?? '',
      doseNumber: json['doseNumber'] ?? 0,
      ageInterval: json['ageInterval'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      createdBy: json['createdBy'] ?? '',
      modifiedAt: json['modifiedAt'],
      modifiedBy: json['modifiedBy'],
      disease: Disease.fromJson(json['disease'] ?? {}),
    );
  }
}

class Disease {
  final int diseaseId;
  final String name;
  final String species;
  final String description;

  Disease({
    required this.diseaseId,
    required this.name,
    required this.species,
    required this.description,
  });

  factory Disease.fromJson(Map<String, dynamic> json) {
    return Disease(
      diseaseId: json['diseaseId'] ?? 0,
      name: json['name'] ?? '',
      species: json['species'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
