import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/constant/api_url.dart';
import '../../../core/network/dio_client.dart';
import '../../../service_locator.dart';

abstract class PetRecordService {
  Future<Either> getPetRecord(int petId);
}

class PetRecordServiceImpl extends PetRecordService {
  @override
  Future<Either> getPetRecord(int petId) async {
    try {
      final url = '${ApiUrl.getVaccineProfileByPetId}/$petId';
      final response = await sl<DioClient>().get(url);
      return Right(response.data);
    } on DioException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Exception('An unexpected error occurred'));
    }
  }
}
