import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/constant/api_url.dart';
import '../../../core/network/dio_client.dart';
import '../../../service_locator.dart';
import '../models/put_microchip_appointment_note.dart';

abstract class MicrochipAppointmentNoteDetailService {
  Future<Either> getMicrochipAppointmentNoteDetail(int appointmentId);
  Future<Either> putMicrochipAppointmentNoteDetail(PutMicrochipAppointmentModel appointmentUpdate);
}

class MicrochipAppointmentNoteDetailServiceImpl
    extends MicrochipAppointmentNoteDetailService {
  @override
  Future<Either> getMicrochipAppointmentNoteDetail(int appointmentId) async {
    try {
      var response = await sl<DioClient>().get(
        '${ApiUrl.getAppointmentForMicrochipById}/$appointmentId',
      );

      return Right(response.data);
    } on DioException catch (e) {
      return Left('Lỗi mạng: ${e.message}');
    } catch (e) {
      return Left('Lỗi không xác định: $e');
    }
  }

  @override
  Future<Either> putMicrochipAppointmentNoteDetail(PutMicrochipAppointmentModel appointmentUpdate) async {
    try {
      final url =
          '${ApiUrl.putUpdateAppointmentForMicrochip}/${appointmentUpdate.appointmentId}';

      // Sử dụng JSON body thay vì form data
      final jsonBody = appointmentUpdate.toJson();

      final response = await sl<DioClient>().put(
        url,
        data: jsonBody, // Gửi JSON body
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      return Right(response.data);
    } on DioException catch (e) {
      return Left('Lỗi : ${e.response?.data['message']}');
    } catch (e) {
      return Left('Lỗi không xác định: $e');
    }
  }
}
