import 'package:equatable/equatable.dart';
import '../../../domain/appointment/entities/future_appointment.dart';

abstract class FutureAppointmentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FutureAppointmentLoading extends FutureAppointmentState {}

// Thêm state mới cho việc tải thêm dữ liệu (khi người dùng kéo xuống để load trang tiếp theo)
class FutureAppointmentLoadingMore extends FutureAppointmentState {
  final List<FutureAppointmentEntity> appointments;
  final int currentPage;

  FutureAppointmentLoadingMore({
    required this.appointments,
    required this.currentPage,
  });

  @override
  List<Object?> get props => [appointments, currentPage];
}

class FutureAppointmentLoaded extends FutureAppointmentState {
  final List<FutureAppointmentEntity> appointments;
  final bool hasMoreData;
  final int currentPage;

  FutureAppointmentLoaded({
    required this.appointments,
    this.hasMoreData = true,
    this.currentPage = 1,
  });

  @override
  List<Object?> get props => [appointments, hasMoreData, currentPage];
}

class FutureAppointmentError extends FutureAppointmentState {
  final String message;

  FutureAppointmentError({required this.message});

  @override
  List<Object?> get props => [message];
}