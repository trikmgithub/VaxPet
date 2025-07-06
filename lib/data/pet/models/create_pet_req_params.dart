class CreatePetReqParams {
  final int customerId;
  final String name;
  final String species;
  final String breed;
  final String gender;
  final String dateOfBirth;
  final String placeToLive;
  final String placeOfBirth;
  final String? image;
  final String weight;
  final String color;
  final String nationality;
  final bool isSterilized;

  CreatePetReqParams({
    required this.customerId,
    required this.name,
    required this.species,
    required this.breed,
    required this.gender,
    required this.dateOfBirth,
    required this.placeToLive,
    required this.placeOfBirth,
    this.image,
    required this.weight,
    required this.color,
    required this.nationality,
    required this.isSterilized,
  });

  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'name': name,
      'species': species,
      'breed': breed,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'placeToLive': placeToLive,
      'placeOfBirth': placeOfBirth,
      'image': image,
      'weight': weight,
      'color': color,
      'nationality': nationality,
      'isSterilized': isSterilized,
    };
  }
}
