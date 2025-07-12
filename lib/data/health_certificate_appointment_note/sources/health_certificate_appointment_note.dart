import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/constant/api_url.dart';
import '../../../core/network/dio_client.dart';
import '../../../service_locator.dart';

abstract class HealthCertificateAppointmentNoteService {
  Future<Either> getHealthCertificateAppointmentNote(int petId, int status);
}

class HealthCertificateAppointmentNoteServiceImpl extends HealthCertificateAppointmentNoteService {
  @override
  Future<Either> getHealthCertificateAppointmentNote(int petId, int status) async {
    try {
      var response = await sl<DioClient>().get(
        '${ApiUrl.getAppointmentForHealthCertificateByPetIdAndStatus}/$petId/$status',
      );
      return Right(response.data);
    } on DioException catch (e) {
      return Left(e.response!.data['message']);
    }
  }
}
