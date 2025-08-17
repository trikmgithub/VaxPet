import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/constant/api_url.dart';
import '../../../core/network/dio_client.dart';
import '../../../service_locator.dart';

abstract class VaccineAppointmentNoteDetailService {
  Future<Either> getVaccineAppointmentNoteDetail(int appointmentId);
  Future<Either> getAppointmentDetailForVaccinationById(int appointmentId);
}

class VaccineAppointmentNoteDetailServiceImpl
    extends VaccineAppointmentNoteDetailService {
  @override
  Future<Either> getVaccineAppointmentNoteDetail(int appointmentId) async {
    try {
      var response = await sl<DioClient>().get(
        '${ApiUrl.getAppointmentForVaccinationById}/$appointmentId',
      );

      return Right(response.data);
    } on DioException catch (e) {
      return Left('Lỗi mạng: ${e.message}');
    } catch (e) {
      return Left('Lỗi không xác định: $e');
    }
  }

  @override
  Future<Either> getAppointmentDetailForVaccinationById(int appointmentId) async {
    try {
      var response = await sl<DioClient>().get(
        '${ApiUrl.getAppointmentDetailForVaccinationById}/$appointmentId',
      );

      return Right(response.data);
    } on DioException catch (e) {
      return Left('Lỗi mạng: ${e.message}');
    } catch (e) {
      return Left('Lỗi không xác định: $e');
    }
  }
}
