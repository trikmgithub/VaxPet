import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/constant/api_url.dart';
import '../../../core/network/dio_client.dart';
import '../../../service_locator.dart';

abstract class AppointmentService {
  Future<Either> getAppointmentByCustomerAndStatus(int customerId, String status);
}

class AppointmentServiceImpl extends AppointmentService {
  @override
  Future<Either> getAppointmentByCustomerAndStatus(int customerId, String status) async {
    try {
      var response = await sl<DioClient>().get(
        '${ApiUrl.getAppointmentByCustomerAndStatus}/$customerId/$status',
      );

      return Right(response.data);
    } on DioException catch (e) {
      return Left('Lỗi mạng: ${e.message}');
    } catch (e) {
      return Left('Lỗi không xác định: $e');
    }
  }

}