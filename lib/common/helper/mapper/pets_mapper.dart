import '../../../data/pet/models/pet.dart';
import '../../../domain/pet/entities/pet.dart';

class PetsMapper {
  static PetEntity toEntity(PetParams pet) {
    return PetEntity(
      petId: pet.petId,
      customerId: pet.customerId,
      petCode: pet.petCode,
      name: pet.name,
      species: pet.species,
      breed: pet.breed,
      age: pet.age,
      gender: pet.gender,
      dateOfBirth: pet.dateOfBirth,
      placeToLive: pet.placeToLive,
      placeOfBirth: pet.placeOfBirth,
      image: pet.image,
      weight: pet.weight,
      color: pet.color,
      nationality: pet.nationality,
      isSterilized: pet.isSterilized,
      microchipItems: pet.microchipItems,
    );
  }
}
