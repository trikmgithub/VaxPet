import 'package:dartz/dartz.dart';
import 'package:vaxpet/common/helper/mapper/pets_mapper.dart';
import 'package:vaxpet/data/pet/models/create_pet_req_params.dart';
import 'package:vaxpet/data/pet/sources/pet.dart';
import 'package:vaxpet/domain/pet/entities/pet.dart';
import 'package:vaxpet/domain/pet/repositories/pet.dart';

import '../../../service_locator.dart';
import '../models/pet.dart';

class PetRepositoryImpl extends PetRepository {
  @override
  Future<Either<String, List<PetEntity>>> getPets(int accountId) async {
    var returnedData = await sl<PetService>().getPets(accountId);

    return returnedData.fold(
        (error) {
          return Left(error.toString());
        },
        (data) {
          try {
            if (data is List) {
              final List<PetEntity> petsList = [];

              for (var item in data) {
                if (item is Map<String, dynamic> &&
                    item.containsKey('data') &&
                    item['success'] == true) {

                  var petData = item['data'];

                  var petModel = PetParams.fromJson(petData);
                  var petEntity = PetsMapper.toEntity(petModel);

                  petsList.add(petEntity);
                }
              }

              return Right(petsList);
            } else {
              return Left('Invalid data format');
            }
          } catch (e) {
            return Left('Error processing pet data: $e');
          }
        },
    );
  }

  @override
  Future<Either> createPet(CreatePetReqParams pet) async {
    var returnedData = await sl<PetService>().createPet(pet);
    return returnedData.fold(
      (error) => Left(error.toString()),
      (data) {
        return Right(data);
      },
    );
  }


}