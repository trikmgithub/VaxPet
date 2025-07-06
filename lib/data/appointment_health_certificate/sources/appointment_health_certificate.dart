import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/constant/api_url.dart';
import '../../../core/network/dio_client.dart';
import '../../../service_locator.dart';
import '../models/post_appointment_health_certificate.dart';

abstract class AppointmentHealthCertificateService {
  // Post
  Future<Either> postAppointmentHealthCertificate(
    PostAppointmentHealthCertificateModel? params,
  );
}

class AppointmentHealthCertificateServiceImpl
    implements AppointmentHealthCertificateService {
  @override
  Future<Either> postAppointmentHealthCertificate(
    PostAppointmentHealthCertificateModel? params,
  ) async {
    try {
      final url = ApiUrl.postAppointmentForHealthCertificate;
      final response = await sl<DioClient>().post(
        url,
        data: {
          "appointment": {
            "customerId": params?.customerId,
            "petId": params?.petId,
            "appointmentDate": params?.appointmentDate,
            "serviceType": params?.serviceType,
            "location": params?.location,
            "address": params?.address,
          },
        },
      );
      return Right(response.data);
    } on DioException catch (e) {
      return Left('Lỗi kết nối mạng! ${e.message}');
    } catch (e) {
      return Left('Lỗi tại postAppointmentMicrochip: ${e.toString()}');
    }
  }
}
