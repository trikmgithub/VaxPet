import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:vaxpet/core/network/dio_client.dart';
import '../../../core/constant/api_url.dart';
import '../../../service_locator.dart';
import '../models/post_appointment_vaccination.dart';

abstract class AppointmentVaccinationService {
  // Post
  Future<Either> postAppointmentVaccination(
    PostAppointmentVaccinationModel params,
  );
}

class AppointmentVaccinationServiceImpl
    implements AppointmentVaccinationService {
  @override
  Future<Either> postAppointmentVaccination(
    PostAppointmentVaccinationModel params,
  ) async {
    try {
      final url = ApiUrl.postAppointmentForVaccination;
      final response = await sl<DioClient>().post(url, data: params.toMap());
      return Right(response.data);
    } on DioException catch (e) {
      debugPrint('DioException: ${e.message}');
      return Left('Lỗi kết nối mạng!');
    } catch (e) {
      return Left('Lỗi tại postAppointmentVaccination: ${e.toString()}');
    }
  }
}
