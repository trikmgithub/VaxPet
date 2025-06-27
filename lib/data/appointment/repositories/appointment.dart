import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:vaxpet/common/helper/mapper/past_appointment_mapper.dart';

import '../../../common/helper/mapper/future_appointment_mapper.dart';
import '../../../common/helper/mapper/today_appointment_mapper.dart';
import '../../../domain/appointment/entities/future_appointment.dart';
import '../../../domain/appointment/entities/past_appointment.dart';
import '../../../domain/appointment/entities/today_appointment.dart';
import '../../../domain/appointment/repositories/appointment.dart';
import '../../../service_locator.dart';
import '../models/future_appointment.dart';
import '../models/past_appointment.dart';
import '../models/today_appointment.dart';
import '../sources/appointment.dart';

class AppointmentRepositoryImpl extends AppointmentRepository {
  @override
  Future<Either> getAppointmentByCustomerAndStatus(
    int customerId,
    String status,
  ) async {
    var returnedData = await sl<AppointmentService>()
        .getAppointmentByCustomerAndStatus(customerId, status);

    return returnedData.fold(
            (error) => Left(Exception(error.toString())),
            (data) {
          var appointmentDetail = data;
          return Right(appointmentDetail);
        }
    );
  }

  @override
  Future<Either> getAppointmentById(int appointmentId) async {
    var returnedData = await sl<AppointmentService>().getAppointmentById(
      appointmentId,
    );

    return returnedData.fold(
            (error) => Left(Exception(error.toString())),
            (data) {
          var appointmentDetail = data;
          return Right(appointmentDetail);
        }
    );
  }

  @override
  Future<Either> getFutureAppointmentByCusId(int customerId, int pageNumber, int pageSize) async {
    var returnedData = await sl<AppointmentService>()
        .getFutureAppointmentByCusId(
        customerId, pageNumber, pageSize
    );

    return returnedData.fold(
          (error) => Left(Exception(error.toString())),
          (data) {
        if (data['data'] == null) {
          return Right(<FutureAppointmentEntity>[]); // Explicit empty list with type
        }

        final response = data['data'];
        final responseData = response['pageData'];
        final List<FutureAppointmentEntity> appointmentDetail = List.from(responseData)
            .map<FutureAppointmentEntity>((item) => FutureAppointmentMapper.toEntity(
            FutureAppointmentModel.fromJson(item)))
            .toList();
        return Right(appointmentDetail);
      },
    );
  }

  @override
  Future<Either> getPastAppointmentByCusId(int customerId, int pageNumber, int pageSize) async {
    var returnedData = await sl<AppointmentService>().getPastAppointmentByCusId(
      customerId, pageNumber, pageSize
    );

    return returnedData.fold(
          (error) => Left(Exception(error.toString())),
          (data) {
        if (data['data'] == null) {
          return Right(<PastAppointmentEntity>[]); // Explicit empty list with type
        }

        final response = data['data'];
        final responseData = response['pageData'];
        final List<PastAppointmentEntity> appointmentDetail = List.from(responseData)
            .map<PastAppointmentEntity>((item) => PastAppointmentMapper.toEntity(
            PastAppointmentModel.fromJson(item)))
            .toList();
        return Right(appointmentDetail);
      },
    );
  }

  @override
  Future<Either> getTodayAppointmentByCusId(int customerId, int pageNumber, int pageSize) async {
    var returnedData = await sl<AppointmentService>()
        .getTodayAppointmentByCusId(
        customerId, pageNumber, pageSize
    );

    return returnedData.fold(
      (error) => Left(Exception(error.toString())),
      (data) {
        if (data['data'] == null) {
          return Right(<TodayAppointmentEntity>[]); // Explicit empty list with type
        }

        final response = data['data'];
        final responseData = response['pageData'];
        final List<TodayAppointmentEntity> appointmentDetail = List.from(responseData)
            .map<TodayAppointmentEntity>((item) => TodayAppointmentMapper.toEntity(
                TodayAppointmentModel.fromJson(item)))
            .toList();
        return Right(appointmentDetail);
      },
    );
  }
}
