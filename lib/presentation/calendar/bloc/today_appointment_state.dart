import 'package:equatable/equatable.dart';
import 'package:vaxpet/domain/appointment/entities/past_appointment.dart';

import '../../../domain/appointment/entities/today_appointment.dart';

abstract class TodayAppointmentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TodayAppointmentLoading extends TodayAppointmentState {}

// Thêm state mới cho việc tải thêm dữ liệu (khi người dùng kéo xuống để load trang tiếp theo)
class TodayAppointmentLoadingMore extends TodayAppointmentState {
  final List<TodayAppointmentEntity> appointments;
  final int currentPage;

  TodayAppointmentLoadingMore({
    required this.appointments,
    required this.currentPage,
  });

  @override
  List<Object?> get props => [appointments, currentPage];
}

class TodayAppointmentLoaded extends TodayAppointmentState {
  final List<TodayAppointmentEntity> appointments;
  final bool hasMoreData;
  final int currentPage;

  TodayAppointmentLoaded({
    required this.appointments,
    this.hasMoreData = true,
    this.currentPage = 1,
  });

  @override
  List<Object?> get props => [appointments, hasMoreData, currentPage];
}

class TodayAppointmentError extends TodayAppointmentState {
  final String message;

  TodayAppointmentError({required this.message});

  @override
  List<Object?> get props => [message];
}