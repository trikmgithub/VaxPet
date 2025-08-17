import 'package:equatable/equatable.dart';

enum AppointmentRejectReasonStatus {
  initial,
  loading,
  success,
  failure,
}

class AppointmentRejectReasonState extends Equatable {
  const AppointmentRejectReasonState({
    this.status = AppointmentRejectReasonStatus.initial,
    this.rejectReason = '',
    this.appointmentCode = '',
    this.errorMessage,
  });

  final AppointmentRejectReasonStatus status;
  final String rejectReason;
  final String appointmentCode;
  final String? errorMessage;

  AppointmentRejectReasonState copyWith({
    AppointmentRejectReasonStatus? status,
    String? rejectReason,
    String? appointmentCode,
    String? errorMessage,
  }) {
    return AppointmentRejectReasonState(
      status: status ?? this.status,
      rejectReason: rejectReason ?? this.rejectReason,
      appointmentCode: appointmentCode ?? this.appointmentCode,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, rejectReason, appointmentCode, errorMessage];
}
