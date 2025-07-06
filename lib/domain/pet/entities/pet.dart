class PetEntity {
  final int? petId;
  final int? customerId;
  final String? petCode;
  final String? name;
  final String? species;
  final String? breed;
  final String? age;
  final String? gender;
  final String? dateOfBirth;
  final String? placeToLive;
  final String? placeOfBirth;
  final String? image;
  final String? weight;
  final String? color;
  final String? nationality;
  final bool? isSterilized;

  PetEntity({
    this.petId,
    this.customerId,
    this.petCode,
    this.name,
    this.species,
    this.breed,
    this.age,
    this.gender,
    this.dateOfBirth,
    this.placeToLive,
    this.placeOfBirth,
    this.image,
    this.weight,
    this.color,
    this.nationality,
    this.isSterilized,
  });
}
