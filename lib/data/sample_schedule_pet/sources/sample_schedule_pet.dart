import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/constant/api_url.dart';
import '../../../core/network/dio_client.dart';
import '../../../service_locator.dart';

abstract class SampleSchedulePetService {
  // Get
  Future<Either> getSampleSchedulePet(String species);
}

class SampleSchedulePetServiceImpl extends SampleSchedulePetService {
  @override
  Future<Either> getSampleSchedulePet(String species) async {
    try {
      final url = '${ApiUrl.getVaccineSchedule}/$species';

      final response = await sl<DioClient>().get(url);

      return Right(response.data);
    } on DioException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Exception('An unexpected error occurred'));
    }
  }
  
}