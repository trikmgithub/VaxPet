import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:vaxpet/core/constant/api_url.dart';
import 'package:vaxpet/core/network/dio_client.dart';

import '../../../service_locator.dart';

abstract class VaccineAppointmentNoteService {
  Future<Either> getVaccineAppointmentNote(int petId, int status);
}

class VaccineAppointmentNoteServiceImpl extends VaccineAppointmentNoteService {
  @override
  Future<Either> getVaccineAppointmentNote(int petId, int status) async {
    try {
      var response = await sl<DioClient>().get(
        '${ApiUrl.getAppointmentByPetAndStatus}/$petId/$status',
      );
      return Right(response.data);
    } on DioException catch(e) {
      return Left(e.response!.data['message']);
    }
  }

}