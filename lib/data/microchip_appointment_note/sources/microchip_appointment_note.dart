import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/constant/api_url.dart';
import '../../../core/network/dio_client.dart';
import '../../../service_locator.dart';

abstract class MicrochipAppointmentNoteService {
  Future<Either> getMicrochipAppointmentNote(int petId, int status);
}

class MicrochipAppointmentNoteServiceImpl extends MicrochipAppointmentNoteService {
  @override
  Future<Either> getMicrochipAppointmentNote(int petId, int status) async {
    try {
      var response = await sl<DioClient>().get(
        '${ApiUrl.getAppointmentForMicrochipByPetIdAndStatus}/$petId/$status',
      );
      return Right(response.data);
    } on DioException catch (e) {
      return Left(e.response!.data['message']);
    }
  }
}