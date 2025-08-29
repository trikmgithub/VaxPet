import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:vaxpet/core/network/dio_client.dart';

import '../../../core/constant/api_url.dart';
import '../../../service_locator.dart';
import '../models/post_appointment_micrcochip.dart';

abstract class AppointmentMicrochipService {
  // Post
  Future<Either> postAppointmentMicrochip(PostAppointmentMicrochipModel params);
  // Put
  Future<Either> cancelAppointmentMicrochip(int appointmentId);
}

class AppointmentMicrochipServiceImpl implements AppointmentMicrochipService {
  @override
  Future<Either> postAppointmentMicrochip(
    PostAppointmentMicrochipModel params,
  ) async {
    try {
      final url = ApiUrl.postAppointmentForMicrochip;
      final response = await sl<DioClient>().post(url, data: params.toMap());
      return Right(response.data);
    } on DioException catch (e) {
      return Left('Lỗi: ${e.response?.data['message']}');
    } catch (e) {
      return Left('Lỗi tại postAppointmentMicrochip: ${e.toString()}');
    }
  }

  @override
  Future<Either> cancelAppointmentMicrochip(int appointmentId) async {
    try {
      final url = ApiUrl.putCancelAppointmentForMicrochip;

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
