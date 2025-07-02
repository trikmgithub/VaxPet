import 'package:equatable/equatable.dart';
import 'package:vaxpet/domain/appointment/entities/past_appointment.dart';

abstract class PastAppointmentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PastAppointmentLoading extends PastAppointmentState {}

// Thêm state mới cho việc tải thêm dữ liệu (khi người dùng kéo xuống để load trang tiếp theo)
class PastAppointmentLoadingMore extends PastAppointmentState {
  final List<PastAppointmentEntity> appointments;
  final int currentPage;

  PastAppointmentLoadingMore({
    required this.appointments,
    required this.currentPage,
  });

  @override
  List<Object?> get props => [appointments, currentPage];
}

class PastAppointmentLoaded extends PastAppointmentState {
  final List<PastAppointmentEntity> appointments;
  final bool hasMoreData;
  final int currentPage;

  PastAppointmentLoaded({
    required this.appointments,
    this.hasMoreData = true,
    this.currentPage = 1,
  });

  @override
  List<Object?> get props => [appointments, hasMoreData, currentPage];
}

class PastAppointmentError extends PastAppointmentState {
  final String message;

  PastAppointmentError({required this.message});

  @override
  List<Object?> get props => [message];
}