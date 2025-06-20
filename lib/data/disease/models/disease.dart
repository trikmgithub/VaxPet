class DiseaseModel {
  final int? diseaseId;
  final String? name;
  final String? description;
  final String? species;
  final String? symptoms;
  final String? treatment;
  final String? status;

  DiseaseModel({
    this.diseaseId,
    this.name,
    this.description,
    this.species,
    this.symptoms,
    this.treatment,
    this.status,
  });

  factory DiseaseModel.fromJson(Map<String, dynamic> json) {
    return DiseaseModel(
      diseaseId: json['diseaseId'],
      name: json['name'],
      description: json['description'],
      species: json['species'],
      symptoms: json['symptoms'],
      treatment: json['treatment'],
      status: json['status'],
    );
  }
}