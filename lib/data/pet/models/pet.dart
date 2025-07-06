class PetParams {
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

  PetParams({
    required this.petId,
    required this.customerId,
    required this.petCode,
    required this.name,
    required this.species,
    required this.breed,
    required this.age,
    required this.gender,
    required this.dateOfBirth,
    required this.placeToLive,
    required this.placeOfBirth,
    required this.image,
    required this.weight,
    required this.color,
    required this.nationality,
    required this.isSterilized,
  });

  factory PetParams.fromJson(Map<String, dynamic> json) {
    return PetParams(
      petId: json["petId"],
      customerId: json["customerId"],
      petCode: json["petCode"],
      name: json["name"],
      species: json["species"],
      breed: json["breed"],
      age: json["age"],
      gender: json["gender"],
      dateOfBirth: json["dateOfBirth"],
      placeToLive: json["placeToLive"],
      placeOfBirth: json["placeOfBirth"],
      image: json["image"],
      weight: json["weight"],
      color: json["color"],
      nationality: json["nationality"],
      isSterilized: json["isSterilized"],
    );
  }
}
