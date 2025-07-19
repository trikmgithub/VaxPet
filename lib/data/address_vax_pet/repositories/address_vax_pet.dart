import 'package:dartz/dartz.dart';

import '../../../domain/address_vax_pet/repositories/address_vax_pet.dart';
import '../../../service_locator.dart';
import '../sources/address_vax_pet.dart';

class AddressVaxPetRepositoryImpl extends AddressVaxPetRepository {
  @override
  Future<Either> getAddressVaxPet() async {
    var returnedData = await sl<AddressVaxPetService>().getAddressVaxPetById();

    return returnedData.fold(
      (error) => Left(Exception(error.toString())),
      (data) {
        var addressVaxPetDetail = data;
        return Right(addressVaxPetDetail);
      },
    );
  }
}