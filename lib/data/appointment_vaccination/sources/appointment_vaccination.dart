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
  // Put
  Future<Either> cancelAppointmentVaccination(
    int appointmentId,
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
      return Left('Lỗi: ${e.response?.data['message']}');
    } catch (e) {
      return Left('Lỗi tại postAppointmentVaccination: ${e.toString()}');
    }
  }

  @override
  Future<Either> cancelAppointmentVaccination(int appointmentId) async {
    try {
      final url = '${ApiUrl.putUpdateAppointmentForVaccination}/$appointmentId';

      // Sử dụng FormData cho multipart/form-data
      final formData = FormData.fromMap({
        'appointmentId': appointmentId,
        'appointmentStatus': 10, // Assuming 10 is the status for cancellation
      });

      final response = await sl<DioClient>().put(url, data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );
      return Right(response.data);
    } on DioException catch (e) {
      debugPrint('DioException: ${e.message}');
      return Left('Lỗi kết nối mạng!');
    } catch (e) {
      return Left('Lỗi tại cancelAppointmentVaccination: ${e.toString()}');
    }
  }
}
