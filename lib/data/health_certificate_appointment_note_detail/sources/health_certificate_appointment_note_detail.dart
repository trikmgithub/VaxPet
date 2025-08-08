import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/constant/api_url.dart';
import '../../../core/network/dio_client.dart';
import '../../../service_locator.dart';
import '../models/put_health_certificate_appointment_note.dart';

abstract class HealthCertificateAppointmentNoteDetailService {
  Future<Either> getHealthCertificateAppointmentNoteDetail(int appointmentId);
  Future<Either> putHealthCertificateAppointmentNoteDetail(PutHealthCertificateAppointmentModel appointmentUpdate);
}

class HealthCertificateAppointmentNoteDetailServiceImpl
    extends HealthCertificateAppointmentNoteDetailService {
  @override
  Future<Either> getHealthCertificateAppointmentNoteDetail(int appointmentId) async {
    try {
      var response = await sl<DioClient>().get(
        '${ApiUrl.getAppointmentForHealthCertificateById}/$appointmentId',
      );

      return Right(response.data);
    } on DioException catch (e) {
      return Left('Lỗi: ${e.response?.data['message']}');
    } catch (e) {
      return Left('Lỗi không xác định: $e');
    }
  }

  @override
  Future<Either> putHealthCertificateAppointmentNoteDetail(PutHealthCertificateAppointmentModel appointmentUpdate) async {
    try {
      final url =
          '${ApiUrl.updateAppointmentForHealthCertificate}/${appointmentUpdate.appointmentId}';

      // Sử dụng JSON body thay vì form data
      final jsonBody = appointmentUpdate.toJson();

      final response = await sl<DioClient>().put(
        url,
        data: jsonBody, // Gửi JSON body
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      return Right(response.data);
    } on DioException catch (e) {
      return Left('Lỗi: ${e.response?.data['message']}');
    } catch (e) {
      return Left('Lỗi không xác định: $e');
    }
  }
}