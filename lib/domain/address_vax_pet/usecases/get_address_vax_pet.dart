import 'package:dartz/dartz.dart';
import 'package:vaxpet/core/usecase/usecase.dart';

import '../../../service_locator.dart';
import '../repositories/address_vax_pet.dart';

class GetAddressVaxPetUseCase extends UseCase<Either, void> {
  @override
  Future<Either> call({void params}) async {
    return await sl<AddressVaxPetRepository>().getAddressVaxPet();
  }

}