import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/constant/api_url.dart';
import '../../../core/network/dio_client.dart';
import '../../../service_locator.dart';

abstract class AppointmentService {
  Future<Either> getAppointmentByCustomerAndStatus(int customerId, String status);
  Future<Either> getAppointmentById(int appointmentId);
  Future<Either> getPastAppointmentByCusId(int customerId, int pageNumber, int pageSize);
  Future<Either> getTodayAppointmentByCusId(int customerId, int pageNumber, int pageSize);
  Future<Either> getFutureAppointmentByCusId(int customerId, int pageNumber, int pageSize);
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

  @override
  Future<Either> getAppointmentById(int appointmentId) async {
    try {
      var response = await sl<DioClient>().get(
        '${ApiUrl.getAppointmentById}/$appointmentId',
      );

      return Right(response.data);
    } on DioException catch (e) {
      return Left('Lỗi mạng: ${e.message}');
    } catch (e) {
      return Left('Lỗi không xác định: $e');
    }
  }

  @override
  Future<Either> getFutureAppointmentByCusId(int customerId, int pageNumber, int pageSize) async {
    try {
      var response = await sl<DioClient>().get(
        '${ApiUrl.getFutureAppointmentByCusId}/$customerId',
        queryParameters: {
          'pageNumber': pageNumber,
          'pageSize': pageSize,
        },
      );
      return Right(response.data);
    } on DioException catch (e) {
      return Left('Lỗi mạng: ${e.message}');
    } catch (e) {
      return Left('Lỗi không xác định: $e');
    }
  }

  @override
  Future<Either> getPastAppointmentByCusId(int customerId, int pageNumber, int pageSize) async {
    try {
      var response = await sl<DioClient>().get(
        '${ApiUrl.getPastAppointmentByCusId}/$customerId',
        queryParameters: {
          'pageNumber': pageNumber,
          'pageSize': pageSize,
        },
      );
      return Right(response.data);
    } on DioException catch (e) {
      return Left('Lỗi mạng: ${e.message}');
    } catch (e) {
      return Left('Lỗi không xác định: $e');
    }
  }

  @override
  Future<Either> getTodayAppointmentByCusId(int customerId, int pageNumber, int pageSize) async {
    try {
      var response = await sl<DioClient>().get(
        '${ApiUrl.getTodayAppointmentByCusId}/$customerId',
        queryParameters: {
          'pageNumber': pageNumber,
          'pageSize': pageSize,
        },
      );
      return Right(response.data);
    } on DioException catch (e) {
      return Left('Lỗi mạng: ${e.message}');
    } catch (e) {
      return Left('Lỗi không xác định: $e');
    }
  }

}