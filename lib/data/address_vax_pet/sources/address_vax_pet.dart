import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/constant/api_url.dart';
import '../../../core/network/dio_client.dart';
import '../../../service_locator.dart';

abstract class AddressVaxPetService {
  Future<Either> getAddressVaxPetById();
}

class AddressVaxPetServiceImpl extends AddressVaxPetService {
  @override
  Future<Either> getAddressVaxPetById() async {
    try {
      // var response = await Future.delayed(
      //   Duration(seconds: 1),
      //   () => {'id': 1, 'address': '123 Vax Pet Street'},
      // );

      var response = await sl<DioClient>().get(
        ApiUrl.getAddressPetVax
      );

      return Right(response.data);
    } on DioException catch (e) {
      return Left('Lỗi mạng: ${e.message}');
    } catch (e) {
      return Left('Lỗi không xác định: $e');
    }
  }
}