import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:vaxpet/core/constant/api_url.dart';

import '../models/create_app_vac_req_params.dart';

abstract class ScheduleService {
  Future<Either> createAppointmentVaccinationHome(CreateAppVacReqParams params);
}

class ScheduleServiceImpl extends ScheduleService {
  final Dio _dio = Dio();

  @override
  Future<Either> createAppointmentVaccinationHome(CreateAppVacReqParams params) async {
    try {
      final url = ApiUrl.createAppointmentVaccination;
      final response = await _dio.post(
        ApiUrl.baseURL + url,
        data: params.toMap(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.data);
      } else {
        return Left(Exception('Failed to create appointment: ${response.statusMessage}'));
      }

    } on DioException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Exception('An unexpected error occurred'));
    }
  }
}